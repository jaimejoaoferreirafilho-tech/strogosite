-- Migração 002 — segurança do aceite intermitente
-- Executar UMA VEZ no Supabase SQL Editor, depois de setup-supabase.sql.
-- IMPORTANTE: revisar e testar em ambiente de homologação antes de usar com funcionários.
begin;
alter table public.profiles add column if not exists approved boolean not null default false;
alter table public.commitments add column if not exists terms_version text;
alter table public.commitments add column if not exists terms_text text;
alter table public.commitments add column if not exists shift_snapshot jsonb;
alter table public.commitments add column if not exists accepted_at timestamptz;
update public.commitments set accepted_at=confirmed_at where accepted_at is null;
alter table public.commitments alter column accepted_at set default now();

-- Nenhuma alteração ou exclusão do aceite por usuários do site, inclusive administradores.
-- Correções excepcionais deverão ter fluxo administrativo auditado, a implementar separadamente.
create or replace function public.block_commitment_mutation()
returns trigger language plpgsql set search_path=public as $$
begin
  raise exception 'Confirmação definitiva: alteração ou exclusão não permitida.';
end; $$;
drop trigger if exists commitments_immutable on public.commitments;
create trigger commitments_immutable before update or delete on public.commitments
for each row execute function public.block_commitment_mutation();

-- Registrar integralmente os dados da oferta e a versão da declaração aceita.
create or replace function public.confirm_shift(p_shift_id uuid)
returns uuid language plpgsql security definer set search_path=public as $$
declare
  v_shift public.shifts%rowtype;
  v_taken integer;
  v_id uuid;
  v_profile public.profiles%rowtype;
  v_terms constant text := 'Declaro aceitar definitivamente a demanda indicada, com data, horários, intervalo e condições apresentados. Estou ciente de que não posso cancelar nem alterar minha confirmação pelo sistema. O descumprimento sem justo motivo está sujeito às consequências legais aplicáveis; impedimentos justificados devem ser comunicados à empresa.';
begin
  if auth.uid() is null then raise exception 'Faça login para confirmar.'; end if;
  select * into v_profile from public.profiles where id=auth.uid();
  if not found or (v_profile.role <> 'admin' and not v_profile.approved) then
    raise exception 'Seu cadastro ainda não foi autorizado pela empresa.';
  end if;
  select * into v_shift from public.shifts where id=p_shift_id for update;
  if not found or v_shift.status <> 'aberta' then
    raise exception 'Esta demanda não está mais disponível.';
  end if;
  if (v_shift.work_date + v_shift.start_time) <= (now() at time zone 'America/Sao_Paulo') then
    raise exception 'Esta demanda já começou.';
  end if;
  if exists (select 1 from public.commitments where shift_id=p_shift_id and user_id=auth.uid()) then
    raise exception 'Você já confirmou esta demanda.';
  end if;
  select count(*) into v_taken from public.commitments where shift_id=p_shift_id;
  if v_taken >= v_shift.vagas then raise exception 'As vagas desta demanda já foram preenchidas.'; end if;
  insert into public.commitments(shift_id,user_id,terms_version,terms_text,shift_snapshot,accepted_at)
  values(p_shift_id,auth.uid(),'2026-11-v1',v_terms,
    jsonb_build_object('work_date',v_shift.work_date,'start_time',v_shift.start_time,
      'end_time',v_shift.end_time,'break_minutes',v_shift.break_minutes,
      'vagas',v_shift.vagas,'observacao',v_shift.observacao),now())
  returning id into v_id;
  return v_id;
end; $$;

-- Impede apagar uma demanda com aceites existentes, evitando exclusão em cascata.
create or replace function public.block_confirmed_shift_delete()
returns trigger language plpgsql set search_path=public as $$
begin
  if exists(select 1 from public.commitments where shift_id=old.id) then
    raise exception 'Demanda com confirmações não pode ser excluída.';
  end if;
  return old;
end; $$;
drop trigger if exists confirmed_shift_delete_guard on public.shifts;
create trigger confirmed_shift_delete_guard before delete on public.shifts
for each row execute function public.block_confirmed_shift_delete();

-- Não expor edição de aprovação por funcionários.
revoke update(approved) on public.profiles from authenticated;
-- Aprovação inicial exclusivamente no SQL Editor; fluxo administrativo será implementado posteriormente.
commit;

-- Exemplo de aprovação individual APÓS conferência de identidade e vínculo:
-- update public.profiles set approved=true where email='funcionario@exemplo.com';
