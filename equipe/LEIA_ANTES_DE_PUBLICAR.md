# Área da equipe — instruções de homologação

Este desenvolvimento está isolado na branch feature/area-intermitentes. Não publicar ainda.

## Banco
A fonte original é setup-supabase.sql, já executada pelo proprietário.
**Escolha apenas um caminho:** o arquivo supabase/INSTALACAO_UNICA_HOMOLOGACAO.sql foi preparado para substituir as migrações numeradas 002-007 em um banco que recebeu apenas o setup original. NÃO executar ambos os caminhos. O script consolidado ainda precisa de revisão e teste em banco separado.

## Operação
- Cadastro por e-mail e senha; a aprovação é concedida pelo administrador.
- Somente funcionário aprovado pode aceitar oferta, por função transacional.
- Aceite guarda cópia das condições e texto aceito; registros são imutáveis.
- Administração pode criar e cancelar ofertas com justificativa.
- Cancelamento administrativo não exclui compromissos.
- O botão de WhatsApp abre conversa manual; nenhum envio automático foi ativado.
- A fila notification_outbox registra solicitações de aviso, mas exige serviço backend para envio.

## Testes antes de liberar
1. Usuário não aprovado não confirma via RPC.
2. Funcionário não altera role/approved por API.
3. Duas contas concorrendo à última vaga: só uma confirma.
4. Não é possível atualizar ou apagar compromissos via API.
5. Não é possível apagar uma oferta com compromissos.
6. Alterações de horários/vagas em oferta aceita são recusadas.
7. Administrador cancela com motivo e o histórico permanece.
8. Um usuário só lê seus próprios aceites; admin lê os da equipe.
9. Fuso de Brasília, virada de dia e horários noturnos.
10. Verificar fluxo de e-mail de cadastro e recuperação de senha.
11. Revisão jurídica das mensagens e política de dados pessoais.

## Limitações
Sem acesso administrativo ao Supabase e à Vercel, não foi possível aplicar scripts, testar RLS em produção, publicar preview nem validar notificações.
