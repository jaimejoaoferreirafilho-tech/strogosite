-- 007: revisão final sobre o schema original setup-supabase.sql
-- Executar somente após 002-006, em ambiente de testes.
begin;
-- Corrige o problema de cascata: registros de aceite não podem desaparecer
-- se a oferta ou o perfil forem excluídos.
alter table public.commitments drop constraint if exists commitments_shift_id_fkey;
alter table public.commitments add constraint commitments_shift_id_fkey
 foreign key (shift_id) references public.shifts(id) on delete restrict;
alter table public.commitments drop constraint if exists commitments_user_id_fkey;
alter table public.commitments add constraint commitments_user_id_fkey
 foreign key (user_id) references public.profiles(id) on delete restrict;

-- Remove permissão de exclusão herdada do setup original.
drop policy if exists commitments_admin_delete on public.commitments;
revoke insert,update,delete on public.commitments from authenticated;
revoke insert,update,delete on public.commitments from anon;
revoke insert,update,delete on public.shifts from authenticated;
revoke insert,update,delete on public.shifts from anon;

-- Impede mudança direta de status, inclusive por funções futuras.
-- Cancelamento administrativo permanece restrito à função RPC abaixo.
create or replace function public.guard_shift_status()
returns trigger language plpgsql set search_path=public as $$
begin
 if new.status is distinct from old.status then
  if old.status='cancelada' then raise exception 'Demanda cancelada não pode ser reaberta'; end if;
  if current_setting('app.shift_cancel_authorized',true) is distinct from 'yes' then
   raise exception 'Status somente pode ser alterado por cancelamento administrativo';
  end if;
 end if;
 return new;
end $$;
drop trigger if exists guard_shift_status_trigger on public.shifts;
create trigger guard_shift_status_trigger before update on public.shifts
for each row execute function public.guard_shift_status();

create or replace function public.admin_cancel_shift(p_shift_id uuid,p_reason text)
returns void language plpgsql security definer set search_path=public as $$
declare v_status text;
begin
 if not public.is_admin() then raise exception 'Acesso negado'; end if;
 if length(trim(coalesce(p_reason,'')))<5 then raise exception 'Informe motivo com cinco caracteres ou mais'; end if;
 select status into v_status from public.shifts where id=p_shift_id for update;
 if not found then raise exception 'Demanda não encontrada'; end if;
 if v_status='cancelada' then raise exception 'Demanda já cancelada'; end if;
 perform set_config('app.shift_cancel_authorized','yes',true);
 update public.shifts set status='cancelada' where id=p_shift_id;
 perform set_config('app.shift_cancel_authorized','',true);
 insert into public.shift_events(shift_id,actor_id,event_type,reason)
 values(p_shift_id,auth.uid(),'cancelamento',trim(p_reason));
end $$;
revoke all on function public.admin_cancel_shift(uuid,text) from public,anon;
grant execute on function public.admin_cancel_shift(uuid,text) to authenticated;
commit;
