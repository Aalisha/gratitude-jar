drop table if exists letters;

create table letters (
  id         text primary key,
  user_id    uuid not null default auth.uid() references auth.users(id) on delete cascade,
  text       text not null,
  date       text not null,
  created_at timestamptz default now()
);

alter table letters enable row level security;

create policy "read own letters"   on letters for select using (auth.uid() = user_id);
create policy "add own letters"    on letters for insert with check (auth.uid() = user_id);
create policy "delete own letters" on letters for delete using (auth.uid() = user_id);
