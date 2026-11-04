-- 006: Demandas criadas apenas por administrador, via RPC.
begin;
revoke insert,update,delete on public.shifts from authenticated;
create or replace function public.admin_create_shift(p_work_date date,p_start_time time,p_end_time time,p_break_minutes integer,p_vagas integer,p_observacao text)
returns uuid language plpgsql security definer set search_path=public as $$
declare v_id uuid;
begin
 if not public.is_admin() then raise exception 'Acesso negado'; end if;
 if p_vagas not between 1 and 100 or p_break_minutes not between 0 and 720 then raise exception 'Dados inválidos'; end if;
 if p_work_date+p_start_time <= now() at time zone 'America/Sao_Paulo' then raise exception 'Data no passado'; end if;
 insert into public.shifts(work_date,start_time,end_time,break_minutes,vagas,observacao)
 values(p_work_date,p_start_time,p_end_time,p_break_minutes,p_vagas,p_observacao) returning id into v_id;
 return v_id;
end $$;
revoke all on function public.admin_create_shift(date,time,time,integer,integer,text) from public,anon;
grant execute on function public.admin_create_shift(date,time,time,integer,integer,text) to authenticated;
commit;
