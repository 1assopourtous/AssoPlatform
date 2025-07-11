import { Context } from 'hono';
import { D1Database } from '@cloudflare/workers-types';

export function getDB(c: Context): D1Database {
  return c.env.DB;
}

export const DB = {
  async ensureUserSchema(db: D1Database) {
    const info = await db.prepare('PRAGMA table_info(users)').all();
    const hasPassword = info.results?.some((r: any) => r.name === 'password_hash');
    if (!hasPassword) {
      await db
        .prepare('ALTER TABLE users ADD COLUMN password_hash TEXT')
        .run();
    }
  },
  async getUserByEmail(db: D1Database, email: string) {
    const result = await db
      .prepare('SELECT * FROM users WHERE email = ?')
      .bind(email)
      .first();
    return result;
  },

  async createUser(db: D1Database, user: {
    id: string;
    email: string;
    passwordHash: string;
    role: string;
  }) {
    await db
      .prepare('INSERT INTO users (id, email, password_hash, role) VALUES (?, ?, ?, ?)')
      .bind(user.id, user.email, user.passwordHash, user.role)
      .run();
    // create wallet for new user
    await db
      .prepare('INSERT INTO wallets (id, user_id, balance) VALUES (?, ?, 0)')
      .bind(crypto.randomUUID(), user.id)
      .run();
  }
,
  async getWalletByUserId(db: D1Database, userId: string) {
    return db
      .prepare('SELECT * FROM wallets WHERE user_id = ?')
      .bind(userId)
      .first();
  },

  async getTransactions(db: D1Database, walletId: string) {
    return db
      .prepare('SELECT * FROM transactions WHERE wallet_id = ? ORDER BY created_at DESC')
      .bind(walletId)
      .all();
  },

  async getNotifications(db: D1Database, userId: string) {
    return db
      .prepare('SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC')
      .bind(userId)
      .all();
  },

  async markNotificationRead(db: D1Database, id: string) {
    await db
      .prepare('UPDATE notifications SET is_read = 1 WHERE id = ?')
      .bind(id)
      .run();
  },

  async getUsersWithBalances(db: D1Database) {
    return db
      .prepare(
        'SELECT u.id, u.email, u.role, COALESCE(w.balance, 0) as balance FROM users u LEFT JOIN wallets w ON u.id = w.user_id'
      )
      .all();
  }
};
