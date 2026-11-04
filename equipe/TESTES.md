# Testes antes da publicação

Status: protótipo. Não executar migrações na produção sem revisão.

1. Conferir a estrutura das tabelas existentes no Supabase.
2. Validar as políticas RLS e permissões dos perfis.
3. Verificar se list_shifts retorna os campos usados pelo site.
4. Testar login e aprovação de funcionário.
5. Testar concorrência de duas confirmações na última vaga.
6. Confirmar que funcionário não altera ou exclui o aceite via API.
7. Confirmar que cancelamentos administrativos mantêm histórico.
8. Confirmar que demanda cancelada não recebe novos aceites.
9. Testar proteção dos dados pessoais.
10. Validar horário de Brasília.
11. Testar fila de notificações e envio real antes de anunciar automação.
12. Revisar juridicamente o texto do aceite e casos de ausência justificada.

A migração 002 impede UPDATE de commitments, inclusive o campo antigo notified.
A fila de notificações não envia mensagens sem um serviço backend.
Não publicar na branch main até concluir a homologação.
