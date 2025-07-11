import { verifyJWT, decodeJWT } from './jwt';
const JWT_SECRET = 'supersecret';
export async function authenticate(c, next) {
    const header = c.req.header('Authorization') || '';
    const token = header.replace('Bearer ', '');
    if (!token || !(await verifyJWT(token, JWT_SECRET))) {
        return c.json({ error: 'Unauthorized' }, 401);
    }
    const payload = decodeJWT(token);
    c.set('user', payload);
    await next();
}
export function authorize(role) {
    return async (c, next) => {
        const user = c.get('user');
        if (!user || user.role !== role) {
            return c.json({ error: 'Forbidden' }, 403);
        }
        await next();
    };
}
