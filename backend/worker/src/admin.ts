import { Hono } from 'hono';
import { verifyJwt } from './lib/auth';    // маленький хелпер

export const admin = new Hono();

/** Middleware: only admin */
admin.use('*', async (c, next) => {
  const jwt = c.req.header('authorization')?.replace('Bearer ', '');
  if (!jwt) return c.json({ error: 'no token' }, 401);

  const payload = await verifyJwt(jwt);
  if (payload?.role !== 'admin') return c.json({ error: 'forbidden' }, 403);

  c.set('uid', payload.sub);
  await next();
});

/* ---- users ---- */

admin.get('/users', async c => {
  const sb = createSb(c.req.raw);
  const { data } = await sb.from('auth.users').select('id,email,role,created_at');
  return c.json(data);
});

admin.patch('/users/:id', async c => {
  const { role } = await c.req.json();
  const sb = createSb(c.req.raw);
  await sb.from('auth.users').update({ role }).eq('id', c.req.param('id'));
  return c.json({ ok: true });
});

/* ---- stats ---- */
admin.get('/stats', async c => {
  const sb = createSb(c.req.raw);
  const { data } = await sb.from('v_stats_usercount').select('*').single();
  return c.json(data);
});

/* ---- send notification ---- */
admin.post('/notify', async c => {
  const body = await c.req.json();              // {title, body, userIds[]}

  const sb = createSb(c.req.raw);
  await sb.from('notifications').insert(
    body.userIds.map((id: string) => ({
      user_id: id,
      title: body.title,
      body : body.body
    }))
  );

  /* e-mail через Resend */
  await sendEmail(body);

  return c.json({ ok: true });
});
