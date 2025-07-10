import { v4 as uuidv4 } from "uuid";

export default {
  async fetch(request: Request, env: any): Promise<Response> {
    const url = new URL(request.url);
    const path = url.pathname;
    const method = request.method;

    const db = env.DB;

    // POST /signup (не требует заголовка x-user-id)
    if (method === "POST" && path === "/signup") {
      const body = await request.json();
      const { email, role } = body;
      const user_id = uuidv4();
      const wallet_id = uuidv4();

      await db.batch([
        db.prepare(`INSERT INTO users (id, email, role) VALUES (?, ?, ?)`)
          .bind(user_id, email, role || "member"),

        db.prepare(`INSERT INTO wallets (id, user_id) VALUES (?, ?)`)
          .bind(wallet_id, user_id)
      ]);

      return new Response(JSON.stringify({ user_id, wallet_id }), {
        headers: { "Content-Type": "application/json" }
      });
    }

    const userId = request.headers.get("x-user-id");
    if (!userId) {
      return new Response("Missing x-user-id header", { status: 400 });
    }

    // GET /wallet
    if (method === "GET" && path === "/wallet") {
      const result = await db.prepare(`SELECT * FROM wallets WHERE user_id = ?`)
        .bind(userId).first();
      return new Response(JSON.stringify(result || {}), {
        headers: { "Content-Type": "application/json" },
      });
    }

    // POST /transaction
    if (method === "POST" && path === "/transaction") {
      const body = await request.json();
      const { amount, type } = body;
      if (!amount || !["credit", "debit"].includes(type)) {
        return new Response("Invalid data", { status: 400 });
      }
      const wallet = await db.prepare(`SELECT * FROM wallets WHERE user_id = ?`)
        .bind(userId).first();
      if (!wallet) return new Response("Wallet not found", { status: 404 });

      const newBalance = type === "credit"
        ? wallet.balance + amount
        : wallet.balance - amount;

      await db.batch([
        db.prepare(`INSERT INTO transactions (id, wallet_id, amount, type) VALUES (?, ?, ?, ?)`)
          .bind(uuidv4(), wallet.id, amount, type),
        db.prepare(`UPDATE wallets SET balance = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?`)
          .bind(newBalance, wallet.id)
      ]);

      return new Response(JSON.stringify({ success: true }));
    }

    // GET /transactions
    if (method === "GET" && path === "/transactions") {
      const wallet = await db.prepare(`SELECT id FROM wallets WHERE user_id = ?`)
        .bind(userId).first();
      if (!wallet) return new Response("Wallet not found", { status: 404 });

      const result = await db.prepare(`
        SELECT * FROM transactions
        WHERE wallet_id = ?
        ORDER BY created_at DESC
        LIMIT 100
      `).bind(wallet.id).all();

      return new Response(JSON.stringify(result.results), {
        headers: { "Content-Type": "application/json" },
      });
    }

    // GET /notifications
    if (method === "GET" && path === "/notifications") {
      const result = await db.prepare(`SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC`)
        .bind(userId).all();
      return new Response(JSON.stringify(result.results), {
        headers: { "Content-Type": "application/json" },
      });
    }

    // POST /notifications
    if (method === "POST" && path === "/notifications") {
      const body = await request.json();
      const { title, body: message } = body;
      await db.prepare(`INSERT INTO notifications (id, user_id, title, body) VALUES (?, ?, ?, ?)`)
        .bind(uuidv4(), userId, title, message).run();
      return new Response(JSON.stringify({ success: true }));
    }

    return new Response("Not found", { status: 404 });
  }
};
