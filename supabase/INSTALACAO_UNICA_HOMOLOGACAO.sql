-- INSTALACAO UNICA PARA HOMOLOGACAO (substitui 002 a 007; NAO executar ambas)
-- Base: setup-supabase.sql original. Revise em projeto de testes.
begin;
alter table public.profiles add column if not exists approved boolean not null default false;
alter table public.commitments add column if not exists terms_version text;
alter table public.commitments add column if not exists terms_text text;
alter table public.commitments add column if not exists shift_snapshot jsonb;
alter table public.commitments add column if not exists accepted_at timestamptz;
update public.commitments set accepted_at=confirmed_at where accepted_at is null;
alter table public.commitments alter column accepted_at set default now();

-- Troca ON DELETE CASCADE por RESTRICT, inclusive para os aceites históricos.
alter table public.commitments drop constraint if exists commitments_shift_id_fkey;
alter table public.commitments add constraint commitments_shift_id_fkey
 foreign key(shift_id) references public.shifts(id) on delete restrict;
alter table public.commitments drop constraint if exists commitments_user_id_fkey;
alter table public.commitments add constraint commitments_user_id_fkey
 foreign key(user_id) references public.profiles(id) on delete restrict;

create or replace function public.immutable_commitment()
returns trigger language plpgsql set search_path=public as $$
begin
 raise exception 'Compromisso definitivo: alteração e exclusão não permitidas';
end $$;
drop trigger if exists immutable_commitment_guard on public.commitments;
create trigger immutable_commitment_guard before update or delete on public.commitments
for each row execute function public.immutable_commitment();

create or replace function public.preserve_accepted_shift()
returns trigger language plpgsql set search_path=public as $$
begin
 if exists(select 1 from public.commitments where shift_id=old.id) and
    row(new.work_date,new.start_time,new.end_time,new.break_minutes,new.vagas,new.observacao)
    is distinct from
    row(old.work_date,old.start_time,old.end_time,old.break_minutes,old.vagas,old.observacao) then
  raise exception 'Oferta já aceita não pode ter suas condições modificadas';
 end if;
 if old.status='cancelada' and new.status <> 'cancelada' then
  raise exception 'Oferta cancelada não pode ser reaberta';
 end if;
 return new;
end $$;
drop trigger if exists preserve_accepted_shift_guard on public.shifts;
create trigger preserve_accepted_shift_guard before update on public.shifts
for each row execute function public.preserve_accepted_shift();

create table if not exists public.shift_events(
 id uuid primary key default gen_random_uuid(),
 shift_id uuid not null references public.shifts(id) on delete restrict,
 actor_id uuid references public.profiles(id) on delete restrict,
 event_type text not null check(event_type in ('cancelamento','nota')),
 reason text not null check(length(trim(reason))>=5),
 created_at timestamptz not null default now()
);
alter table public.shift_events enable row level security;
drop policy if exists shift_events_admin_read on public.shift_events;
create policy shift_events_admin_read on public.shift_events for select to authenticated using(public.is_admin());
revoke all on public.shift_events from anon,authenticated;
grant select on public.shift_events to authenticated;

create table if not exists public.notification_outbox(
 id uuid primary key default gen_random_uuid(),
 commitment_id uuid not null unique references public.commitments(id) on delete restrict,
 created_at timestamptz not null default now(),
 sent_at timestamptz,
 attempts int not null default 0,
 last_error text
);
alter table public.notification_outbox enable row level security;
revoke all on public.notification_outbox from anon,authenticated;
create or replace function public.queue_commitment_notice()
returns trigger language plpgsql security definer set search_path=public as $$
begin
 insert into public.notification_outbox(commitment_id) values(new.id)
 on conflict(commitment_id) do nothing;
 return new;
end $$;
drop trigger if exists queue_commitment_notice_trigger on public.commitments;
create trigger queue_commitment_notice_trigger after insert on public.commitments
for each row execute function public.queue_commitment_notice();
revoke all on function public.queue_commitment_notice() from public,anon,authenticated;

-- RLS e grants: nenhum usuário comum grava compromissos ou muda papel.
drop policy if exists commitments_admin_delete on public.commitments;
revoke insert,update,delete on public.commitments from anon,authenticated;
revoke insert,update,delete on public.shifts from anon,authenticated;
revoke update on public.profiles from authenticated;
grant update(full_name,phone) on public.profiles to authenticated;
revoke insert,delete on public.profiles from authenticated;

create or replace function public.confirm_shift(p_shift_id uuid)
returns uuid language plpgsql security definer set search_path=public as $$
declare v_shift public.shifts%rowtype;v_taken int;v_id uuid;v_approved boolean;
v_terms constant text := 'Aceito definitivamente a demanda, com data, horario, intervalo e condicoes apresentados. Nao poderei cancelar nem alterar esta confirmacao pelo sistema. Impedimentos justificados devem ser comunicados a empresa; consequencias legais dependem das circunstancias.';
begin
 if auth.uid() is null then raise exception 'Faça login'; end if;
 select approved into v_approved from public.profiles where id=auth.uid() and role='intermitente';
 if coalesce(v_approved,false)=false then raise exception 'Cadastro não autorizado'; end if;
 select * into v_shift from public.shifts where id=p_shift_id for update;
 if not found or v_shift.status <> 'aberta' then raise exception 'Demanda indisponível'; end if;
 if (v_shift.work_date+v_shift.start_time) <= now() at time zone 'America/Sao_Paulo' then raise exception 'Demanda já iniciada'; end if;
 if exists(select 1 from public.commitments where shift_id=p_shift_id and user_id=auth.uid()) then raise exception 'Já confirmado'; end if;
 select count(*) into v_taken from public.commitments where shift_id=p_shift_id;
 if v_taken >= v_shift.vagas then raise exception 'Vagas esgotadas'; end if;
 insert into public.commitments(shift_id,user_id,terms_version,terms_text,shift_snapshot,accepted_at)
 values(p_shift_id,auth.uid(),'2026-11-v1',v_terms,to_jsonb(v_shift),now())
 returning id into v_id;
 return v_id;
end $$;
revoke all on function public.confirm_shift(uuid) from public,anon;
grant execute on function public.confirm_shift(uuid) to authenticated;

create or replace function public.admin_set_approval(p_user_id uuid,p_approved boolean)
returns void language plpgsql security definer set search_path=public as $$
begin
 if not public.is_admin() then raise exception 'Acesso negado'; end if;
 if p_user_id=auth.uid() then raise exception 'Operação inválida'; end if;
 update public.profiles set approved=p_approved where id=p_user_id and role='intermitente';
 if not found then raise exception 'Funcionário não encontrado'; end if;
end $$;
revoke all on function public.admin_set_approval(uuid,boolean) from public,anon;
grant execute on function public.admin_set_approval(uuid,boolean) to authenticated;

create or replace function public.admin_create_shift(
 p_work_date date,p_start_time time,p_end_time time,p_break_minutes integer,p_vagas integer,p_observacao text)
returns uuid language plpgsql security definer set search_path=public as $$
declare v_id uuid;
begin
 if not public.is_admin() then raise exception 'Acesso negado'; end if;
 if p_work_date is null or p_start_time is null or p_end_time is null or
    p_vagas is null or p_vagas not between 1 and 100 or
    p_break_minutes is null or p_break_minutes not between 0 and 720 then
  raise exception 'Dados inválidos'; end if;
 if (p_work_date+p_start_time) <= now() at time zone 'America/Sao_Paulo' then raise exception 'Demanda no passado'; end if;
 insert into public.shifts(work_date,start_time,end_time,break_minutes,vagas,observacao)
 values(p_work_date,p_start_time,p_end_time,p_break_minutes,p_vagas,coalesce(p_observacao,''))
 returning id into v_id;
 return v_id;
end $$;
revoke all on function public.admin_create_shift(date,time,time,integer,integer,text) from public,anon;
grant execute on function public.admin_create_shift(date,time,time,integer,integer,text) to authenticated;

create or replace function public.admin_cancel_shift(p_shift_id uuid,p_reason text)
returns void language plpgsql security definer set search_path=public as $$
declare v_status text;
begin
 if not public.is_admin() then raise exception 'Acesso negado'; end if;
 if length(trim(coalesce(p_reason,'')))<5 then raise exception 'Informe justificativa'; end if;
 select status into v_status from public.shifts where id=p_shift_id for update;
 if not found or v_status='cancelada' then raise exception 'Demanda inexistente ou cancelada'; end if;
 update public.shifts set status='cancelada' where id=p_shift_id;
 insert into public.shift_events(shift_id,actor_id,event_type,reason)
 values(p_shift_id,auth.uid(),'cancelamento',trim(p_reason));
end $$;
revoke all on function public.admin_cancel_shift(uuid,text) from public,anon;
grant execute on function public.admin_cancel_shift(uuid,text) to authenticated;
commit;
