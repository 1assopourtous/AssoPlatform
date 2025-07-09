-- 1. USERS -----------------------------------------------------------
create table if not exists users(
  id uuid primary key default uuid_generate_v4(),
  email text unique not null,
  role text check (role in ('admin','manager','member')) default 'member',
  created_at timestamptz default now()
);

alter table auth.users
  add column if not exists role text default 'member';

-- RLS
alter table users enable row level security;
create policy "Users see only themselves"
  on users for select
  using ( auth.uid() = id );

----------------------------------------------------------------------
-- 2. WALLETS ---------------------------------------------------------
create table if not exists wallets(
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references users(id) on delete cascade,
  balance numeric default 0,
  updated_at timestamptz default now()
);

alter table wallets enable row level security;
create policy "Owner sees wallet"
  on wallets for select
  using ( auth.uid() = user_id );

-- триггер: автоматически создает кошелёк
create or replace function create_wallet()
returns trigger as $$
begin
  insert into wallets(user_id) values(new.id);
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists trg_create_wallet on users;
create trigger trg_create_wallet
  after insert on users
  for each row execute procedure create_wallet();

----------------------------------------------------------------------
-- 3. NOTIFICATIONS ---------------------------------------------------
create table if not exists notifications(
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references users(id) on delete cascade,
  title text,
  body text,
  is_read boolean default false,
  created_at timestamptz default now()
);

alter table notifications enable row level security;
create policy "Owner reads notifications"
  on notifications for select
  using ( auth.uid() = user_id );

create policy "Owner updates read-flag"
  on notifications for update
  using ( auth.uid() = user_id )
  with check ( is_read in (false,true) );

----------------------------------------------------------------------
-- 4. Устройство (FCM токены) опционально ----------------------------
create table if not exists user_devices(
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references users(id) on delete cascade,
  fcm_token text,
  created_at timestamptz default now()
);

alter table user_devices enable row level security;
create policy "Owner manages own devices"
  on user_devices for all
  using ( auth.uid() = user_id )
  with check ( auth.uid() = user_id );
