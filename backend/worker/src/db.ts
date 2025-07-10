import { Context } from 'hono';
import { D1Database } from '@cloudflare/workers-types';

export function getDB(c: Context): D1Database {
  return c.env.DB;
}

export const DB = {
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
  }
};
