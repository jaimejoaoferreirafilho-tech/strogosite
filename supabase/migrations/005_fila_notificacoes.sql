-- Migração 005: fila interna de notificações (não envia mensagens sozinha).
-- Aplicar depois das migrações 002-004 e da revisão de permissões.
begin;
create table if not exists public.notification_outbox (
 id uuid primary key default gen_random_uuid(),
 commitment_id uuid not null unique references public.commitments(id),
 created_at timestamptz not null default now(),
 sent_at timestamptz,
 attempts integer not null default 0,
 last_error text
);
alter table public.notification_outbox enable row level security;
revoke all on public.notification_outbox from anon,authenticated;
create or replace function public.queue_commitment_notice()
returns trigger language plpgsql security definer set search_path=public as $$
begin
 insert into public.notification_outbox(commitment_id) values(new.id)
 on conflict (commitment_id) do nothing;
 return new;
end $$;
drop trigger if exists queue_commitment_notice_trigger on public.commitments;
create trigger queue_commitment_notice_trigger after insert on public.commitments
for each row execute function public.queue_commitment_notice();
revoke all on function public.queue_commitment_notice() from public,anon,authenticated;
commit;
-- A fila é privada e exige um serviço backend com credenciais protegidas
-- para processar e registrar envios reais. Não expor chave secreta no navegador.
