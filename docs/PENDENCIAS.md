
## P2 — Validar alinhamento final da barra de navegação e cargas
**Estado:** IMPLEMENTADO — AGUARDANDO VALIDAÇÃO VISUAL. Commit `1009a50`, `lista-semanal/index.html`. Confirmar que botões Carga estão à direita e na mesma linha de Compras/Cadastros/Movimentações, sem conteúdo rolando visível por trás; testar largura reduzida. A equipe JOI mantém botões próprios.


## P2 — Validar posição dos botões de carga
**Estado:** IMPLEMENTADO — AGUARDANDO VALIDAÇÃO VISUAL. Commit `d02fe77`, `lista-semanal/index.html`. Usuário esclareceu por imagem que a sobreposição afeta Carga Jaraguá / Curitiba / Floripa, não os botões de categoria. Verificar desktop e mobile com menus fixos e durante rolagem. Não alterar checklists nem pedidos.


## P2 — Validar posicionamento dos botões de categoria
**Estado:** IMPLEMENTADO — AGUARDANDO VALIDAÇÃO VISUAL. Commit `284750a`, `lista-semanal/index.html`. Verificar rolagem na tela de compras com menus fixos, especialmente Selecionar todos / Desmarcar todos em desktop e celular, sem sobreposição. Se houver problema, solicitar print da região afetada antes de alterar outras telas.


## P1 — Validar origem automática de todas as compras CARGAJOI
**Estado:** IMPLEMENTADO — AGUARDANDO VALIDAÇÃO. Commit `74f9444`, `lista-semanal/index.html`. Verificar sugestões FLN restauradas e compras avulsas: origem FORNECEDOR JOI, fornecedor Joinville, campos bloqueados, destino preservado e confirmação correta no recebimento. Não há teste autenticado.


## P0 — Validar reenvio de compras após desfazer recebimento FLN
**Estado:** IMPLEMENTADO — AGUARDANDO VALIDAÇÃO. Erro exibido: `Compra sugerida sem contagem válida`. A função `stock_approve_suggested_purchases` exige contagem válida, mas pedidos cancelados podem conter itens com `canceled_source_count_id` e `source_count_id` nulos (comprovado em FLN, produtos acabados). Ajustado o envio destes itens restaurados como compra sem contagem (`ad_hoc=true` apenas na chamada RPC), preservadas quantidades editadas e suprimida reapresentação quando já houver compra ativa para mesmo produto/loja. **Commits:** `f9108b1`, `9c59dc1`; arquivo `lista-semanal/index.html`. Scripts validados sintaticamente; nenhum pedido/estoque foi alterado nesta intervenção. **Próxima ação:** confirmar deploy, reenviar uma única vez, verificar em OP/Recebimentos e confirmar que não há duplicidade. Se persistir, coletar mensagem e inspecionar registros antes de nova tentativa.

# PENDÊNCIAS E ESTADO ATUAL — CASA DO ESTROGONOFE
Atualizado em 18/11/2026. Este é o ponto de retomada obrigatório para novos chats.

## Estado da sessão e continuidade
- **Última tarefa solicitada**: implementar memória permanente do projeto no próprio GitHub; não interrompe o desenvolvimento operacional.
- **Última alteração funcional**: corrigir consulta de sugestões restauradas para incluir `stock_purchase_order_items.id` e respeitar itens ignorados, commit `510d072` (**VALIDADO PELO USUÁRIO** em 18/11/2026: item desapareceu da lista de Curitiba). Anteriormente: separar estrogonofes e Tikka Masala no recebimento CARGAJOI, validado pelo usuário.
- **Arquivo e commit funcional**: `op/index.html`, [5f09c21](https://github.com/jaimejoaoferreirafilho-tech/strogosite/commit/5f09c21be85d15486e6bb5222075afd72310995e).
- **Resultado efetivamente verificado**: validação sintática dos scripts e confirmação explícita do usuário: **“Ficou ótimo.”** Não há teste E2E automatizado comprovado.
- **Deploy funcional conhecido antes da documentação**: Vercel `strogosite`, produção `dpl_D9sBfNJzYb7UbY6KjwvWDACEwkQ2`, estado `READY` consultado em 18/11/2026. **A documentação pode acionar novo deploy; verificar estado novamente.**
- **Última alteração documental**: criação destes três arquivos em `docs/` em commits sucessivos; verificar os commits mais recentes do `main`.
- **Próximo passo exato**: validar despacho de carga pela equipe JOI (commit `8e3ed4c`), depois validar no navegador as melhorias de compra avulsa do commit `cf1874a` (data em lote e defaults CARGAJOI/JOI/Joinville), depois retomar a validação das listas consolidadas de supermercado e fornecedores; não repetir correções já revertidas.

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


## P1 — Validar conclusão e despacho de cargas pela equipe Joinville
**Situação**: **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO**. Commit UI `8e3ed4c`, banco com `stock_cargajoi_dispatched`, RPC `stock_cargajoi_dispatch` e filtro na `stock_cargajoi_picking_list`. A conclusão é por destino/data, exige todos os itens marcados e retira os despachados dos afazeres JOI sem alterar recebimentos.
- **Próxima ação**: equipe JOI marcar todos, clicar Concluir e despachar carga, confirmar que desapareceu mesmo após recarregar, e verificar que a loja destinatária ainda pode receber. Não simular despacho em dados reais.

## P1 — Validar exclusão individual e em lote na compra avulsa
**Situação**: **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO**. Commit `82f298b` corrige a lixeira que antes tentava ignorar uma contagem inexistente e acrescenta Selecionar todos, Desmarcar todos e Excluir selecionados por loja. A exclusão é apenas de rascunhos, não de pedidos confirmados.
- **Próxima ação**: testar na tela da loja errada, apagar individualmente e em lote, trocar de loja e verificar que rascunhos de outras lojas não foram apagados. Confirmar publicação Vercel e registrar resultado do usuário.

## P1 — Validar data em lote e preenchimento automático na compra avulsa
**Situação**: **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO**. Em 18/11/2026, commit `cf1874a` adicionou data única aplicável a todos os itens da loja e defaults para os seis produtos acabados (CARGAJOI / FORNECEDOR JOI / Joinville).
- **Arquivo**: `lista-semanal/index.html`.
- **Testes feitos**: sintaxe dos dois scripts validada. Não houve teste autenticado de UI nem confirmação do usuário.
- **Próxima ação**: conferir deploy e abrir Compra avulsa, adicionar os seis produtos, verificar campos preenchidos e data aplicada em todos, testar confirmação sem alterar destino. Se houver falha, investigar antes de editar.

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
