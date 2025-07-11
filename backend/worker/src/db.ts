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
  }
};
