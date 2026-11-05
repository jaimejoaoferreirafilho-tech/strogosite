-- Migração 004: impedir escalonamento de privilégios e preservar compromissos.
-- Aplicar após 002 e 003, em homologação.
begin;
-- O usuário pode editar somente seus dados de contato, nunca role/approved.
revoke update on public.profiles from authenticated;
grant update (full_name,phone) on public.profiles to authenticated;
revoke insert,delete on public.profiles from authenticated;
-- Aceites só podem ser inseridos pela função confirm_shift (SECURITY DEFINER).
revoke insert,update,delete on public.commitments from authenticated;
-- Evita remoção em cascata do histórico quando um perfil é excluído.
create or replace function public.prevent_profile_delete_with_commitments()
returns trigger language plpgsql set search_path=public as $$
begin
 if exists(select 1 from public.commitments where user_id=old.id) then
  raise exception 'Perfil com compromissos não pode ser excluído';
 end if;
 return old;
end $$;
drop trigger if exists preserve_confirmed_profile on public.profiles;
create trigger preserve_confirmed_profile before delete on public.profiles
for each row execute function public.prevent_profile_delete_with_commitments();
-- Não permitir editar dados de uma oferta já aceita.
create or replace function public.prevent_confirmed_shift_edits()
returns trigger language plpgsql set search_path=public as $$
begin
 if exists(select 1 from public.commitments where shift_id=old.id) then
  if row(new.work_date,new.start_time,new.end_time,new.break_minutes,new.vagas,new.observacao)
    is distinct from row(old.work_date,old.start_time,old.end_time,old.break_minutes,old.vagas,old.observacao) then
    raise exception 'Oferta com compromissos não pode ter suas condições alteradas';
  end if;
 end if;
 return new;
end $$;
drop trigger if exists preserve_confirmed_shift_terms on public.shifts;
create trigger preserve_confirmed_shift_terms before update on public.shifts
for each row execute function public.prevent_confirmed_shift_edits();
commit;
