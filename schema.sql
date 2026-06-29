-- Gratitude Jar — database setup
-- Run this ONCE in your Supabase project: Dashboard -> SQL Editor -> paste -> Run.
-- (This file is kept in the repo for reference only; GitHub does not run it.)
--
-- WARNING: the "drop table" line clears any existing letters. That's fine on
-- first setup / while testing, but remove it if you already have real data.

drop table if exists letters;

create table letters (
  id         text primary key,
  user_id    uuid not null default auth.uid() references auth.users(id) on delete cascade,
  text       text not null,
  date       text not null,
  created_at timestamptz default now()
);

-- Row Level Security: this is what makes each account's letters private.
alter table letters enable row level security;

create policy "read own letters"   on letters for select using (auth.uid() = user_id);
create policy "add own letters"    on letters for insert with check (auth.uid() = user_id);
create policy "delete own letters" on letters for delete using (auth.uid() = user_id);

-- Optional but recommended for a smooth sign-up:
--   Authentication -> Sign In / Providers -> Email -> turn OFF "Confirm email".
