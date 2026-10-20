-- Mi Aula 2.0 — ejecutar en SQL Editor de Supabase
-- Una fila JSON por docente. Acceso exclusivo al dueño con RLS.
create table if not exists public.teacher_workspaces (
  owner_id uuid primary key references auth.users(id) on delete cascade,
  content jsonb not null default '{"courses":[],"active":null}'::jsonb,
  updated_at timestamptz not null default now(),
  constraint workspace_is_object check (jsonb_typeof(content) = 'object')
);
create or replace function public.update_teacher_workspace_timestamp()
returns trigger language plpgsql set search_path = '' as $$
begin new.updated_at = now(); return new; end $$;
drop trigger if exists trg_teacher_workspaces_updated on public.teacher_workspaces;
create trigger trg_teacher_workspaces_updated before update on public.teacher_workspaces
for each row execute function public.update_teacher_workspace_timestamp();
alter table public.teacher_workspaces enable row level security;
revoke all on public.teacher_workspaces from anon, authenticated;
grant select, insert, update, delete on public.teacher_workspaces to authenticated;
drop policy if exists "read own workspace" on public.teacher_workspaces;
drop policy if exists "insert own workspace" on public.teacher_workspaces;
drop policy if exists "update own workspace" on public.teacher_workspaces;
drop policy if exists "delete own workspace" on public.teacher_workspaces;
create policy "read own workspace" on public.teacher_workspaces for select to authenticated using ((select auth.uid()) = owner_id);
create policy "insert own workspace" on public.teacher_workspaces for insert to authenticated with check ((select auth.uid()) = owner_id);
create policy "update own workspace" on public.teacher_workspaces for update to authenticated using ((select auth.uid()) = owner_id) with check ((select auth.uid()) = owner_id);
create policy "delete own workspace" on public.teacher_workspaces for delete to authenticated using ((select auth.uid()) = owner_id);
