import { Hono } from 'hono';
import { cors } from 'hono/cors';
import auth from './auth';

const app = new Hono();

app.use(
  '*',
  cors({
    origin: 'https://assopourtous.com/api',
    allowMethods: ['GET', 'POST', 'OPTIONS'],
    allowHeaders: ['Content-Type', 'Authorization'],
  })
);

// Подключаем маршрут авторизации
app.route('/', auth);

export default app;
