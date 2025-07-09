import { Hono } from 'hono'
import { createClient } from '@supabase/supabase-js'

const app = new Hono()

function sb(r: Request) {
  return createClient(
    SUPABASE_URL,
    SUPABASE_ANON_KEY,
    { global: { headers: { Authorization: r.headers.get('authorization') ?? '' } } }
  )
}

app.get('/health', c => c.json({ ok: true }))
import { admin } from './admin';
app.route('/admin', admin);

app.get('/profile', async c => {
  const supabase = sb(c.req.raw)          // <-- .raw обязательно
  const { data, error } = await supabase.auth.getUser()
  if (error) return c.json({ error: error.message }, 401)
  return c.json({ user: data.user })
})
app.get('/wallet', async c => {
  const sb = createSb(c.req.raw);
  const { data, error } = await sb
    .from('wallets')
    .select('balance,updated_at')
    .single();

  return error
      ? c.json({ error: error.message }, 400)
      : c.json(data);
});

app.get('/notifications', async c => {
  const sb = createSb(c.req.raw);
  const { data, error } = await sb
      .from('notifications')
      .select('*')
      .order('created_at', { ascending: false });
  return error ? c.json({ error: error.message }, 400) : c.json(data);
});

app.post('/notifications/:id/read', async c => {
  const id = c.req.param('id');
  const sb = createSb(c.req.raw);
  const { error } = await sb
      .from('notifications')
      .update({ is_read: true })
      .eq('id', id);
  return error ? c.json({ error: error.message }, 400) : c.json({ ok: true });
});

export default app
