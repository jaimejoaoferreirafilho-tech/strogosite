
24/11/2026 — Segurança: verificar funcionamento de Já comprei e sugestões ignoradas após proteção RLS. Auditar 11 RPCs SECURITY DEFINER acessíveis a anon, 39 a authenticated (podem ser intencionais), proteção de senhas vazadas desabilitada e logs de acesso. Dez avisos INFO RLS sem políticas, incluindo tabelas internas protegidas via RPC; não criar políticas permissivas automaticamente.


24/11/2026 — Validar histórico de contagens (c0be52e): abrir seção admin, filtrar loja/data, consultar contagem com compras já confirmadas, conferir zeros e paginação. Aguardar validação visual e deploy. Nomes/unidades são do cadastro atual.


## P1 — Validar marcação de compras em lote
**Estado:** IMPLEMENTADO — AGUARDANDO VALIDAÇÃO FUNCIONAL. Commit `82bff39`, `lista-semanal/index.html`. Selecionar alguns itens de supermercado/fornecedores, clicar `Já comprei (N)` e confirmar uma vez. Verificar remoção somente dos selecionados, preservação dos demais e continuidade das previsões de recebimento/cargas. Conferir mensagens de erro e atualização do contador.


## P1 — Validar persistência dos rascunhos de compras
**Estado:** IMPLEMENTADO — AGUARDANDO VALIDAÇÃO FUNCIONAL. Commit `ea7ae118`, `lista-semanal/index.html`. Testar fornecedor, data, quantidade, origem e fornecedor individual CARGAJOI; navegar para Recebimento, voltar, recarregar e conferir. Testar confirmação de compra e retirada dos itens confirmados do rascunho. **Limitação conhecida:** `localStorage` não sincroniza entre navegadores ou dispositivos; avaliar persistência no Supabase se necessária.


## P1 — Confirmar retirada de COCA ZERO 350ML das sugestões de Curitiba
**Estado:** IMPLEMENTADO — AGUARDANDO VALIDAÇÃO VISUAL. Commit `5be53f3`. Pedido de 84 UN já existe, previsto para 24/11/2026 com Coca Cola (FEMSA). Filtro de compras sugeridas agora verifica pedidos ativos da loja para evitar duplicação. Conferir após recarregar se item some da sugestão e permanece no Recebimento; não enviar compra novamente.


## P1 — Validar fornecedor individual após seleção geral da categoria
**Estado:** IMPLEMENTADO — AGUARDANDO VALIDAÇÃO FUNCIONAL. Commit `2e23415`, `lista-semanal/index.html`. Testar fornecedor geral, depois trocar fornecedor de um único item, confirmando que os outros mantêm o fornecedor geral e que a escolha individual persiste até confirmação da compra.


## P1 — Validar seletores gerais de origem e fornecedor CARGAJOI
**Estado:** IMPLEMENTADO — AGUARDANDO VALIDAÇÃO FUNCIONAL. Commit `cfc6782`, `lista-semanal/index.html`. Testar categoria com itens CARGAJOI: selecionar SUPERMERCADO e verificar campos individuais; selecionar fornecedor JOI e verificar origem FORNECEDOR_JOINVILLE; confirmar que outras categorias e fornecedores logísticos não são alterados. Confirmar compra somente após conferir itens.


## P2 — Validar novos produtos na próxima contagem
**Estado:** BANCO VALIDADO — INTERFACE AGUARDANDO VALIDAÇÃO. VINAGRE e PAPEL HIGIÊNICO cadastrados em UN; PIMENTA DO REINO oculta nas quatro unidades, PIMENTA EM GRÃO preservada. Conferir na próxima lista semanal aberta; contagens já enviadas permanecem imutáveis. Nenhum pedido foi gerado.


## P1 — Validar visualmente cinco itens CARGAJOI classificados como estoque Joinville
**Estado:** BANCO VALIDADO — INTERFACE AGUARDANDO VALIDAÇÃO. Os cinco itens indicados pela usuária foram atualizados e conferidos no Supabase como `ESTOQUE_JOINVILLE`; commit `3303b11` no código. Verificar após atualização da página que contador de classificação cai em cinco, que itens aparecem na seção produção/estoque disponível e continuam nas listas de separação das cargas, sem aparecer em compras externas.


## P1 — Validar classificação automática de produção própria CARGAJOI
**Estado:** IMPLEMENTADO — AGUARDANDO VALIDAÇÃO FUNCIONAL. Commit `a4589a7`, `lista-semanal/index.html`. Estrogonofes e Tikka Masala devem desaparecer da tabela de classificação, aparecer em Produção própria de Joinville e continuar nas listas de carga. Verificar novo contador e que itens de compra externa permanecem pendentes quando sem fornecedor específico. Não houve mutação de pedidos.


## P0 — Validar redução de pendências após classificar CARGAJOI
**Estado:** IMPLEMENTADO — AGUARDANDO VALIDAÇÃO FUNCIONAL. Commit `0d202cc`, `lista-semanal/index.html`. Causa identificada: tabela apresentava todos os pedidos, não só itens sem classificação. Agora deve diminuir ao salvar SUPERMERCADO ou fornecedor real; conferir persistência após recarregar. Dados Supabase antes da correção: 26 genéricos Joinville, 6 supermercado, 1 fornecedor específico. Não classificar automaticamente os 26 restantes.


## P0 — Classificar itens atuais CARGAJOI antes de sair para compras
**Estado:** IMPLEMENTADO — AGUARDANDO VALIDAÇÃO. Commits `16be314b` e `b15d95e`, `lista-semanal/index.html`. Consulta Supabase mostrou 5 itens supermercado e 28 itens FORNECEDOR_JOINVILLE com fornecedor genérico Joinville. Usuário precisa escolher supermercado ou fornecedor real na tabela de classificação dos pedidos atuais; não supor origem. Confirmar listas consolidadas, datas e quantidades; validar comportamento no navegador. Não modificar estoque/recebimentos/despacho.


## P1 — Validar lixeira em lote das compras sugeridas
**Estado:** IMPLEMENTADO — AGUARDANDO VALIDAÇÃO FUNCIONAL. Commit `626a68c`, `lista-semanal/index.html`. Testar selecionar itens de uma loja, clicar Excluir selecionados, confirmar desaparecimento e persistência após atualizar; testar itens restaurados de pedidos cancelados e relatório de falhas. Não alterar compras já confirmadas.


## Concluído — Confirmação limpa após envio de contagem
**Estado:** VALIDADO PELO USUÁRIO (aparentemente funcionando em 18/11/2026). Commit `5a2190a`, `lista-semanal/index.html`. Testar login JAR após contagem enviada: lista e botões não devem aparecer; mensagem de sucesso deve permanecer após recarga. Verificar que admin continua vendo contagem e sugestões sem perda de dados.


## P1 — Validar botões completamente imóveis durante rolagem
**Estado:** IMPLEMENTADO — AGUARDANDO VALIDAÇÃO VISUAL. Commit `1eeb68c`, `lista-semanal/index.html`. A gravação mostrou movimento residual do contêiner sticky; alterado para fixed e reservado espaço com `#adminNavPlaceholder`. Testar início e fim da rolagem, distância das linhas e cabeçalho, ausência de sobreposição em desktop e telas menores.


## P1 — Validar barra unificada sem rolagem independente
**Estado:** IMPLEMENTADO — AGUARDANDO VALIDAÇÃO VISUAL. Commit `9126110`, `lista-semanal/index.html`. A segunda linha foi movida para dentro da primeira como filha posicionada absolutamente; ambas compartilham um único contêiner sticky. Conferir que botões permanecem totalmente visíveis, sem sobreposição, sem rolagem relativa e sem conteúdo visível na fresta. Não marcar resolvido antes da confirmação.


## P1 — Validar navegação sem fresta e sem sobreposição
**Estado:** IMPLEMENTADO — AGUARDANDO VALIDAÇÃO VISUAL. Commit `fae4876`, `lista-semanal/index.html`. Após `417bee6`, usuário comprovou sobreposição de botões na segunda linha. Restaurado offset de 14px e cobertura opaca da fresta. Verificar rolagem real: duas linhas completamente visíveis e nenhum produto aparecendo entre elas. Não marcar resolvido sem confirmação.


## P2 — Validar eliminação da fresta na navegação congelada
**Estado:** IMPLEMENTADO — AGUARDANDO VALIDAÇÃO VISUAL. Commit `417bee6`, `lista-semanal/index.html`. Usuário mostrou conteúdo de compras rolando entre as duas linhas fixas. Corrigidos margem inferior e cálculo de altura da primeira barra, com junção opaca. Próxima ação: verificar rolagem real e ausência de conteúdo visível na junção em desktop e celular.


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


### 25/11/2026 — Sugestões recorrentes de compra
Corrigido em `lista-semanal/index.html` (commit 2898c2e): pedidos recebidos não bloqueiam novas sugestões de contagens; pedidos previstos bloqueiam duplicidade por unidade/produto; pedidos já vinculados à mesma contagem e descartes continuam protegidos. Recuperação de cancelados mantém filtro histórico anterior. Vercel READY produção confirmado; teste visual autenticado pendente. CREME CULINÁRIO JOI: 5 caixas, mínimo 15; nova compra avulsa de 20 caixas prevista para 26/11 já existente, sem duplicar. Conferir sugestões recuperadas antes de confirmar compras. Próximas etapas: navegação e visualização das listas, automação de compras e depois adoção das OPs.


25/11/2026: por solicitação da administração, ciclo até 23/11 encerrado para sugestões (sem apagar contagens). A partir de 26/11, somente última contagem enviada por unidade, com mínimo do respectivo dia. Cancelados vinculados a contagens antigas não reaparecem. Commit f75b118. Validação visual pendente.


25/11/2026 — Compras: navegação separada por ação (2ad11fa), CARGAJOI interno aceito no RPC e fora das listas de compra; checklist independente da compra. Sugestões futuras recuperam último fornecedor não cancelado por unidade/produto, origem e fornecedor CARGAJOI; rascunhos manuais prevalecem, fornecedor histórico deve continuar habilitado. Histórico paginado (cc0a46d). Pendente validação visual e funcional, indicação item não recebido no checklist e unificação pedidos diretos/Joinville.


25/11/2026 — Importador Analytics agregado publicado (bed83e36, Vercel READY produção). Quatro CSVs: vendas 15 colunas, controle, cancelamentos e conciliação de tamanhos. Validação local e pendências por produto-dia; chave loja/produto/opção. Sem persistência ou baixa. Pendente teste autenticado com ZIP extraído, cobertura completa, mapeamento e composição, persistência admin com RLS, cancelamentos complementares, idempotência e simulação antes do inventário. Não agendar Toqan ainda.


25/11/2026 — Tolerâncias aprovadas e cadastradas no Supabase: acabados e bebidas 0/0; proteínas 2/5; frios 3/7; mercearia 3/10; hortifruti e descartáveis 5/10; limpeza 5/15. Tabelas stock_count_category_tolerances e stock_count_product_tolerances com RLS admin. RPC stock_count_audit_preview calcula saldo registrado até envio da contagem, sempre PENDENTE_BASE_E_VENDAS até inventário e cobertura temporal validada; não é conciliação definitiva, unidades ainda precisam validação. Sem movimentações. Pendente UI, histórico imutável, classificação final, ZIP e composição de venda.
