import { Hono } from 'hono';
import { cors } from 'hono/cors';
import api from './auth';

const app = new Hono();

app.use(
  '*',
  cors({
    // Allow requests from the main site
    origin: 'https://assopourtous.com',
    allowMethods: ['GET', 'POST', 'OPTIONS'],
    allowHeaders: ['Content-Type', 'Authorization'],
  })
);

// Монтируем все API маршруты
app.route('/', api);

export default app;
