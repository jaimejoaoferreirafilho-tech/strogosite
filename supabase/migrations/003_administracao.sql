-- Migração 003: administração da equipe e histórico de cancelamentos
-- DEPENDE da migração 002. Não executar antes dos testes.
begin;

create table if not exists public.shift_events (
  id uuid primary key default gen_random_uuid(),
  shift_id uuid not null references public.shifts(id),
  actor_id uuid references public.profiles(id),
  reason text not null,
  event_type text not null check (event_type in ('cancelamento','nota')),
  created_at timestamptz not null default now()
);
alter table public.shift_events enable row level security;
revoke all on public.shift_events from anon,authenticated;
grant select on public.shift_events to authenticated;
create policy shift_events_admin_read on public.shift_events
for select to authenticated using (public.is_admin());

create or replace function public.admin_set_approval(p_user_id uuid,p_approved boolean)
returns void language plpgsql security definer set search_path=public as $$
begin
  if not public.is_admin() then raise exception 'Acesso negado'; end if;
  if p_user_id=auth.uid() then raise exception 'Não altere sua própria aprovação'; end if;
  update public.profiles set approved=p_approved
  where id=p_user_id and role='intermitente';
  if not found then raise exception 'Funcionário não encontrado'; end if;
end $$;
revoke all on function public.admin_set_approval(uuid,boolean) from public,anon;
grant execute on function public.admin_set_approval(uuid,boolean) to authenticated;

-- Os registros de confirmação são permanentes; nunca apagar por interface.
-- Uma demanda cancelada permanece consultável com seu histórico.
create or replace function public.admin_cancel_shift(p_shift_id uuid,p_reason text)
returns void language plpgsql security definer set search_path=public as $$
declare v_status text;
begin
  if not public.is_admin() then raise exception 'Acesso negado'; end if;
  if length(trim(coalesce(p_reason,''))) < 5 then
    raise exception 'Informe o motivo do cancelamento'; end if;
  select status into v_status from public.shifts where id=p_shift_id for update;
  if not found then raise exception 'Demanda não encontrada'; end if;
  if v_status='cancelada' then raise exception 'Demanda já cancelada'; end if;
  update public.shifts set status='cancelada' where id=p_shift_id;
  insert into public.shift_events(shift_id,actor_id,event_type,reason)
  values(p_shift_id,auth.uid(),'cancelamento',trim(p_reason));
end $$;
revoke all on function public.admin_cancel_shift(uuid,text) from public,anon;
grant execute on function public.admin_cancel_shift(uuid,text) to authenticated;
commit;
