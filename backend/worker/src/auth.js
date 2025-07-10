import { Hono } from 'hono';
import { hashPassword, verifyPassword } from './crypto';
import { signJWT } from './jwt';
import { DB, getDB } from './db'; // getDB теперь импортируется
const JWT_SECRET = 'supersecret';
export async function registerHandler(c) {
    const { email, password } = await c.req.json();
    if (!email || !password)
        return c.json({ error: 'Missing fields' }, 400);
    const db = getDB(c);
    const userCheck = await DB.getUserByEmail(db, email);
    if (userCheck)
        return c.json({ error: 'User already exists' }, 409);
    const passwordHash = await hashPassword(password);
    const id = crypto.randomUUID();
    const role = 'user';
    await DB.createUser(db, { id, email, passwordHash, role });
    const token = await signJWT({ id, email, role }, JWT_SECRET);
    return c.json({ token });
}
export async function loginHandler(c) {
    const { email, password } = await c.req.json();
    if (!email || !password)
        return c.json({ error: 'Missing fields' }, 400);
    const db = getDB(c);
    const user = await DB.getUserByEmail(db, email);
    if (!user)
        return c.json({ error: 'Invalid credentials' }, 401);
    const valid = await verifyPassword(password, String(user.password_hash));
    if (!valid)
        return c.json({ error: 'Invalid credentials' }, 401);
    const token = await signJWT({ id: user.id, email: user.email, role: user.role }, JWT_SECRET);
    return c.json({ token });
}
// 👇 Заменяем Router на полноценный Hono instance
const auth = new Hono();
auth.post('/api/register', registerHandler);
auth.post('/api/login', loginHandler);
export default auth;
