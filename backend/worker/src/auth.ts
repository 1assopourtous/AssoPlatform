import { Hono, Context } from 'hono';
import { hashPassword, verifyPassword } from './crypto';
import { signJWT } from './jwt';
import { DB, getDB } from './db';
import { authenticate, authorize } from './middleware';

const JWT_SECRET = 'supersecret';

export async function registerHandler(c: Context) {
  const { email, password } = await c.req.json();
  if (!email || !password) return c.json({ error: 'Missing fields' }, 400);

  const db = getDB(c);
  await DB.ensureUserSchema(db);
  const userCheck = await DB.getUserByEmail(db, email);

  if (userCheck) return c.json({ error: 'User already exists' }, 409);

  const passwordHash = await hashPassword(password);
  const id = crypto.randomUUID();
  const role = 'user';
  await DB.createUser(db, { id, email, passwordHash, role });

  const token = await signJWT({ id, email, role }, JWT_SECRET);
  return c.json({ token });
}

export async function loginHandler(c: Context) {
  const { email, password } = await c.req.json();
  if (!email || !password) return c.json({ error: 'Missing fields' }, 400);

  const db = getDB(c);
  await DB.ensureUserSchema(db);
  const user = await DB.getUserByEmail(db, email);
  if (!user) return c.json({ error: 'Invalid credentials' }, 401);

  const valid = await verifyPassword(password, String(user.password_hash));
  if (!valid) return c.json({ error: 'Invalid credentials' }, 401);

  const token = await signJWT(
    { id: user.id, email: user.email, role: user.role },
    JWT_SECRET
  );
  return c.json({ token });
}

// 👇 Заменяем Router на полноценный Hono instance
const api = new Hono();

api.post('/api/register', registerHandler);
api.post('/api/login', loginHandler);

api.use('/api/*', authenticate);

api.get('/api/wallet', async (c) => {
  const user = c.get('user' as never) as any;
  const db = getDB(c);
  const wallet = await DB.getWalletByUserId(db, user.id);
  return c.json(wallet ?? { balance: 0 });
});

api.get('/api/transactions', async (c) => {
  const user = c.get('user' as never) as any;
  const db = getDB(c);
  const wallet = await DB.getWalletByUserId(db, user.id);
  if (!wallet) return c.json([]);
  const txs = await DB.getTransactions(db, wallet.id as string);
  return c.json(txs.results);
});

api.get('/api/notifications', async (c) => {
  const user = c.get('user' as never) as any;
  const db = getDB(c);
  const res = await DB.getNotifications(db, user.id);
  return c.json(res.results);
});

api.post('/api/notifications/:id/read', async (c) => {
  const id = c.req.param('id');
  const db = getDB(c);
  await DB.markNotificationRead(db, id);
  return c.json({ success: true });
});

api.get('/api/admin/users', authorize('admin'), async (c) => {
  const db = getDB(c);
  const res = await DB.getUsersWithBalances(db);
  return c.json(res.results);
});

export default api;
