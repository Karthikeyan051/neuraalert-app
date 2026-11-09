-- ==========================================
-- NeuraAlert Supabase Schema Migration
-- Paste this entire script into Supabase SQL Editor and click "RUN"
-- ==========================================

-- 1. Profiles Table (non-medical metadata only)
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  app_version text,
  platform text,
  language text check (language in ('ta','en')),
  created_at timestamptz not null default now(),
  last_seen_at timestamptz
);

alter table public.profiles enable row level security;

create policy "profiles_select_own" on public.profiles
  for select using (auth.uid() = id);

create policy "profiles_insert_own" on public.profiles
  for insert with check (auth.uid() = id);

create policy "profiles_update_own" on public.profiles
  for update using (auth.uid() = id) with check (auth.uid() = id);

-- 2. User Keys Table (for End-to-End Encryption - server never has plaintext keys)
create table if not exists public.user_keys (
  user_id uuid primary key references auth.users(id) on delete cascade,
  kdf text not null,
  kdf_params jsonb not null,
  salt text not null,
  wrapped_key text not null,
  recovery_wrapped_key text,
  created_at timestamptz not null default now()
);

alter table public.user_keys enable row level security;

create policy "user_keys_own" on public.user_keys
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- 3. Encrypted Sync Records (Server only ever stores AES-256-GCM ciphertext blobs)
create table if not exists public.sync_records (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  kind text not null check (kind in ('medicine','schedule','dose_log','setting','alert')),
  ciphertext text not null,
  nonce text not null,
  rev integer not null default 1,
  deleted boolean not null default false,
  server_updated_at timestamptz not null default now()
);

create index if not exists sync_records_user_updated 
  on public.sync_records (user_id, server_updated_at);

alter table public.sync_records enable row level security;

create policy "sync_records_own" on public.sync_records
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Auto-update server_updated_at trigger
create or replace function public.touch_server_updated_at()
returns trigger language plpgsql as $$
begin
  new.server_updated_at = now();
  return new;
end $$;

drop trigger if exists sync_records_touch on public.sync_records;
create trigger sync_records_touch
  before insert or update on public.sync_records
  for each row execute function public.touch_server_updated_at();

-- 4. Admin Overview Function (Protected, zero medical data access)
create or replace function public.admin_user_overview()
returns table (
  id uuid,
  email text,
  created_at timestamptz,
  last_sign_in_at timestamptz,
  last_seen_at timestamptz,
  app_version text,
  platform text
)
language sql security definer set search_path = public, auth as $$
  select u.id, u.email::text, u.created_at, u.last_sign_in_at,
         p.last_seen_at, p.app_version, p.platform
  from auth.users u
  left join public.profiles p on p.id = u.id
  where (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin';
$$;

revoke all on function public.admin_user_overview() from public, anon;
grant execute on function public.admin_user_overview() to authenticated;
