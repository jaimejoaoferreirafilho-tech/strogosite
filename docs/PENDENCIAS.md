# PENDÊNCIAS E ESTADO ATUAL — CASA DO ESTROGONOFE
Atualizado em 18/11/2026. Este é o ponto de retomada obrigatório para novos chats.

## Estado da sessão e continuidade
- **Última tarefa solicitada**: implementar memória permanente do projeto no próprio GitHub; não interrompe o desenvolvimento operacional.
- **Última alteração funcional**: corrigir consulta de sugestões restauradas para incluir `stock_purchase_order_items.id` e respeitar itens ignorados, commit `510d072` (**VALIDADO PELO USUÁRIO** em 18/11/2026: item desapareceu da lista de Curitiba). Anteriormente: separar estrogonofes e Tikka Masala no recebimento CARGAJOI, validado pelo usuário.
- **Arquivo e commit funcional**: `op/index.html`, [5f09c21](https://github.com/jaimejoaoferreirafilho-tech/strogosite/commit/5f09c21be85d15486e6bb5222075afd72310995e).
- **Resultado efetivamente verificado**: validação sintática dos scripts e confirmação explícita do usuário: **“Ficou ótimo.”** Não há teste E2E automatizado comprovado.
- **Deploy funcional conhecido antes da documentação**: Vercel `strogosite`, produção `dpl_D9sBfNJzYb7UbY6KjwvWDACEwkQ2`, estado `READY` consultado em 18/11/2026. **A documentação pode acionar novo deploy; verificar estado novamente.**
- **Última alteração documental**: criação destes três arquivos em `docs/` em commits sucessivos; verificar os commits mais recentes do `main`.
- **Próximo passo exato**: retomar a validação das listas consolidadas de supermercado e fornecedores (P1), ou a próxima melhoria solicitada pelo usuário; não repetir correções já revertidas.

## P0 — Preservação e integridade
**Situação**: CONTÍNUA. Nas tentativas anteriores, uma mudança de `op/index.html` resultou em tela de acesso sem os dados visíveis; rollback restaurou funcionamento.
- **Arquivos**: `op/index.html`, `lista-semanal/index.html`.
- **Tentativas anteriores**: alterações extensas em concatenação HTML, algumas com erro sintático; revertidas em `f948f89` e `4c746d1`.
- **Próxima ação**: mudanças mínimas, revisar diff, validar todos os scripts antes de commit, testar sessão/autenticação, manter rollback. Nunca publicar erro de sintaxe.
- **Estado**: PROTOCOLO PERMANENTE.

## CONCLUÍDO — Exclusão da sugestão BANDEJA ISOPOR RASA
**Situação**: **VALIDADO PELO USUÁRIO** em 18/11/2026 após commit `510d072`: usuário confirmou **“saiu”** ao verificar BANDEJA ISOPOR RASA em Curitiba. Causa: consulta de itens cancelados omitia `id`, inviabilizando `ignoredRestored.has(it.id)`. O `select` agora inclui `id`; scripts passaram na validação sintática. Não houve exclusão de dados ou movimentação de estoque.
- **Evidência no banco**: em consulta de 18/11/2026, item BANDEJA ISOPOR RASA de Curitiba em pedido cancelado aparece com `ignored=true` na tabela `stock_restored_suggestion_ignored`. Existem itens BANDEJA ISOPOR FUNDA distintos; não os apagar por engano.
- **Componentes**: `lista-semanal/index.html`, `purchases()`, `stock_purchase_order_items`, `stock_restored_suggestion_ignored`, `stock_ignore_restored_item`, `stock_ignored_restored_suggestions`, `stock_purchase_suggestion_ignored`.
- **Tentativas**: ignorar por contagem (falhou em sugestões recuperadas), por pedido+produto, por ID de item e marcação direta no banco; o usuário ainda relatou falha visual antes da última verificação.
- **Próxima ação**: nenhuma para este item; manter como teste de regressão ao modificar sugestões restauradas. Não extrapolar a confirmação para outros itens. **Não excluir registros diretamente do banco sem confirmação e autorização do usuário.**
- **Prioridade**: alta, salvo nova orientação.

## P1 — Testar compras consolidadas de supermercado e fornecedores
**Situação**: **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO**.
- **Regras**: agrupar iguais; incluir compras JOI via Fort e Giassi; separar fornecedores como Mercado das Embalagens; retirar lista redundante de Joinville; `Já comprei` remove apenas da lista de compra, preservando recebimento e carga.
- **Componentes**: `renderCargaJoi()`, `stock_local_purchase_checks`, `stock_local_purchase_mark`, `stock_purchase_orders`.
- **Tentativas anteriores**: seção de classificação redundante foi reexibida em uma alteração e posteriormente ocultada.
- **Próxima ação**: conferir visualização real, totais por produto, destino, data, persistência de compra e ausência de movimentação prematura de estoque.
- **Prioridade**: alta para uso diário.

## P2 — Validar separação CARGAJOI para todas as lojas
**Situação**: **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO** de todos os destinos e cenários.
- **Componentes**: `lista-semanal/index.html` (`refreshCargaButtons`, `renderCargaScreen`), `stock_cargajoi_picking_list`, `stock_cargajoi_picking_set`.
- **Próxima ação**: testar botões só quando houver carga, datas, checklists persistentes, separação pela equipe JOI e agrupamento de estrogonofes em JAR/CWB/FLN.
- **Não confundir**: tela de **separação** (`lista-semanal`) e tela de **recebimento** (`op`).

## P2 — Recebimentos CARGAJOI: regressão preventiva
**Situação**: **VALIDADO PELO USUÁRIO** para a separação visual implementada em `5f09c21`.
- **Próxima ação**: apenas testar em novos pedidos/destinos, sem reescrever a rotina que já foi aprovada. Garantir que os campos de quantidade e o botão de confirmação continuam funcionais.
- **Arquivo**: `op/index.html`.

## P2 — Checklist supermercado em celular
**Situação**: **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO**.
- **Sintoma histórico**: popup/lista pequena no celular; CSS inicial não resolveu, houve segunda implementação de tela mais ampla.
- **Próxima ação**: abrir em dispositivo móvel real, verificar escala, tamanho de fonte, checkbox, copiar/WhatsApp, fechamento e persistência esperada.

## P2 — Compra avulsa dos seis produtos acabados
**Situação**: **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO** de compra e recebimento.
- **Produtos**: ESTROGONOFE DE FRANGO; ESTROGONOFE DEFUMADO; ESTROGONOFE DE CARNE; ESTROGONOFE DE MIGNON; ESTROGONOFE TRIFOLATI; TIKKA MASALA.
- **Componentes**: `stock_products`, `stock_supplier_products`, seletor de compra avulsa em `lista-semanal/index.html`.
- **Próxima ação**: conferir seleção por loja, vínculo CARGAJOI, quantidade, previsão e geração de pedido sem duplicar cadastro.

## P3 — Auditoria funcional e técnica para continuidade
**Situação**: A VERIFICAR.
- Inventariar demais arquivos do repositório e funções/Edge Functions relevantes; não presumir ausência por falta de busca.
- Confirmar integração Resend e mensagens; não incluir segredos em docs.
- Revisar permissões reais/RLS de admin, loja e liderança.
- Conferir fichas técnicas e conversões KG/UN, validações de estoque, OP, reversões e rendimentos, sem alterar dados.
- Verificar logs/testes automatizados e possibilidade de validação de interface autenticada.
- Consultar estado do deploy **após commits de documentação** e distinguir publicação de teste de funcionamento.

## Protocolo de atualização
- Toda tarefa nova: registrar objetivo, tela, prioridade e resultado em `PENDENCIAS.md`.
- Toda alteração de código: registrar commit, teste, resultado e status em `HISTORICO_DE_ALTERACOES.md`.
- Toda decisão de regra: atualizar `CONTEXTO_DO_PROJETO.md`.
- Ao final de sessão: atualizar última tarefa, último commit funcional, estado do deploy, resultado real e próximo passo.
- **Nunca marcar como concluído por commit ou deploy apenas.** Usar `IMPLEMENTADO — AGUARDANDO VALIDAÇÃO` quando necessário.
