import { Hono } from 'hono';
import { cors } from 'hono/cors';
import auth from './auth'; // подхватывает все /api/ маршруты
const app = new Hono();
app.use('*', cors({
    origin: (origin) => {
        const allowed = ['http://localhost:61826', 'https://assopourtous.com'];
        return allowed.includes(origin) ? origin : '';
    },
    allowMethods: ['GET', 'POST', 'OPTIONS'],
    allowHeaders: ['Content-Type', 'Authorization']
}));
// Монтируем auth роуты
app.route('/', auth);
export default app;
