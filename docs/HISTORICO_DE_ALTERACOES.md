
### 18/11/2026 — Corrigir sobreposição dos botões de carga
- **Solicitação:** botões Carga Jaraguá, Carga Curitiba e Carga Floripa estavam atrás da navegação fixa de Compras / Cadastros / Movimentações (print do usuário).
- **Causa:** a barra de subnavegação fixa sobrepunha a linha de botões de carga durante a rolagem.
- **Solução:** CSS de posicionamento sticky de `#cargaButtons` abaixo dos menus, com espaçamento e adaptação para telas menores.
- **Arquivo:** `lista-semanal/index.html`; **commit:** `d02fe77`.
- **Teste:** scripts sintaticamente válidos; **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO VISUAL**. Nenhum dado operacional alterado.


### 18/11/2026 — Ajuste de botões das categorias sob menus fixos
- **Solicitação:** impedir que Selecionar todos / Desmarcar todos fiquem atrás da navegação congelada ao rolar a tela de compras.
- **Solução:** linha de ações de categoria com posicionamento sticky abaixo dos menus, espaçamento e adaptação responsiva. Sem mudanças em dados ou regras de compras.
- **Arquivo:** `lista-semanal/index.html`; **commit:** `284750a`.
- **Teste:** scripts passaram na validação sintática; **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO VISUAL**.


### 18/11/2026 — Origem automática para todas as compras CARGAJOI
- **Solicitação:** preencher FORNECEDOR JOI e Joinville sem seleção manual, inclusive em sugestões restauradas FLN.
- **Solução:** defaults automáticos para qualquer item com fornecedor CARGAJOI, campos de origem bloqueados; preservação do destino. Arquivo `lista-semanal/index.html`, commit `74f9444`.
- **Teste:** scripts sintaticamente válidos; **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO** no navegador.

# HISTÓRICO DE ALTERAÇÕES — CASA DO ESTROGONOFE
Atualizado em 18/11/2026. Fonte: commits consultados no GitHub e relatos desta conversa. **Este registro não substitui os diffs e testes reais.**

## Critérios obrigatórios
- **VALIDADO PELO USUÁRIO**: usuário confirmou visualmente/funcionalmente o resultado específico; não implica cobertura de testes automatizados.
- **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO**: código e/ou deploy presentes, sem prova de funcionamento em uso.
- **NÃO RESOLVIDO**: usuário relatou persistência do problema ou tentativa foi revertida.
- **REVERTIDO**: código voltou a versão anterior.
- **INVESTIGAR**: não há evidência suficiente para classificar.
- Commit e deploy `READY` **não comprovam funcionamento**. Registrar data, causa, arquivo, teste e eventual efeito colateral. Nunca inventar datas ou testes ausentes.

## Alterações verificadas no histórico recente

### 18/11/2026 — Separar produtos acabados nos recebimentos CARGAJOI
- **Solicitação**: dentro do mesmo pedido, separar seis produtos (cinco estrogonofes e Tikka Masala) dos demais ingredientes, com cabeçalhos.
- **Causa**: `renderOrders()` em `op/index.html` renderizava todos os itens misturados; tentativas anteriores alteraram tela errada ou quebraram a sintaxe.
- **Solução**: ordenar itens CARGAJOI e inserir cabeçalhos na própria renderização de recebimentos; manter campos e confirmação do pedido.
- **Arquivo**: `op/index.html`.
- **Commit**: [5f09c21](https://github.com/jaimejoaoferreirafilho-tech/strogosite/commit/5f09c21be85d15486e6bb5222075afd72310995e).
- **Teste**: scripts da página passaram por verificação sintática na sessão; usuário respondeu **“Ficou ótimo”** após visualizar o resultado.
- **Estado**: **VALIDADO PELO USUÁRIO** para organização visual mostrada. Sem prova de E2E automatizado.
- **Risco**: conferir novos pedidos, todos os destinos, outros fornecedores e recebimento parcial.

### 17/11/2026 — Tentativas malsucedidas em recebimentos
- **Solicitação**: mesma separação dos estrogonofes.
- **Problema observado**: itens permaneceram misturados; uma tentativa fez a página mostrar tela de acesso sem informações, segundo relato e captura do usuário.
- **Causa técnica confirmada em tentativa posterior**: alterações de concatenação HTML/JavaScript em `op/index.html` falharam em validação sintática; em tentativa anterior a tela de acesso foi restaurada após rollback. Não afirmar causa única da tela de login sem logs.
- **Commits**: [04129e0](https://github.com/jaimejoaoferreirafilho-tech/strogosite/commit/04129e09fee09aedf50d81ebc17e28fcb522d07a), [f948f89](https://github.com/jaimejoaoferreirafilho-tech/strogosite/commit/f948f8964f4f779e01529786c834a382338be7bf), [6b3cd04](https://github.com/jaimejoaoferreirafilho-tech/strogosite/commit/6b3cd04b2568d868b0c23d3855b877526c34626c), [658a141](https://github.com/jaimejoaoferreirafilho-tech/strogosite/commit/658a14176ee4f623b10e8a3778f9a1c8a55655e7), [4c746d1](https://github.com/jaimejoaoferreirafilho-tech/strogosite/commit/4c746d1c5dea624dd30a6249b2bccfe3a853ed4f).
- **Estado histórico**: **NÃO RESOLVIDO/REVERTIDO** até a implementação posterior `5f09c21`.
- **Lição**: sempre identificar `/op/` como tela de recebimento; testar sintaxe **antes** do commit; manter reversão disponível.

### 17/11/2026 — Exclusão de sugestão BANDEJA ISOPOR RASA de Curitiba
- **Solicitação**: lixeira deve ignorar sugestão restaurada de pedido cancelado, sem apagar cadastro ou histórico.
- **Causa identificada**: sugestão restaurada não possui necessariamente contagem de origem, mas rotina antiga de exclusão dependia da contagem.
- **Solução tentada**: `stock_ignore_restored_item` por ID de item, tabela `stock_restored_suggestion_ignored`, filtro em `purchases()`.
- **Arquivo**: `lista-semanal/index.html`; Supabase RPC/tabela.
- **Commit relacionado**: [c196739](https://github.com/jaimejoaoferreirafilho-tech/strogosite/commit/c19673901e4937d403cdffc32326f125f6c6e069). Outras tentativas de ajuste por ID foram feitas posteriormente.
- **Banco**: consulta em 18/11/2026 confirmou item de BANDEJA ISOPOR RASA de CWB em pedido `cancelado`, com `ignored=true`; também existe BANDEJA ISOPOR FUNDA em outros pedidos, que não deve ser confundida.
- **Teste**: persistência de flag confirmada por SQL de leitura. **Não há comprovação de que a lixeira tenha sido testada de ponta a ponta no navegador após a última correção.**
- **Estado**: **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO** do fluxo completo. Histórico anterior de tentativas: **NÃO RESOLVIDO** até confirmação de UI.
- **Risco**: uma sugestão pode ser reconstituída por outra origem/contagem; não excluir diretamente dados produtivos sem identificar o registro e obter autorização.

### 17/11/2026 — Listas de supermercado e confirmação de compra
- **Solicitação**: retirar classificação duplicada, manter supermercado e outros fornecedores, agregar Fort/Giassi, botão `Já comprei` para sumir da lista.
- **Arquivo**: `lista-semanal/index.html`; tabela/RPC `stock_local_purchase_checks`, `stock_local_purchase_checked_ids`, `stock_local_purchase_mark`.
- **Commits**: [f5476e7](https://github.com/jaimejoaoferreirafilho-tech/strogosite/commit/f5476e78c690276c474d321e44cbade0033e9153), [7631505](https://github.com/jaimejoaoferreirafilho-tech/strogosite/commit/763150599702f4f4ff97325c52b0b6146dc15037).
- **Teste**: arquivos e funções presentes; relatos de seção redundante reaparecendo em tentativas anteriores.
- **Estado**: **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO** de consolidação, retirada visual e persistência. Não confundir compra com recebimento/entrada de estoque.

### 17/11/2026 — CARGAJOI separação e checklist
- **Solicitação**: telas Carga Jaraguá/Curitiba/Floripa com separação pela equipe de Joinville, checklists e data.
- **Arquivo**: `lista-semanal/index.html`; RPCs `stock_cargajoi_picking_list` e `stock_cargajoi_picking_set`.
- **Commit relacionado**: [e51f39d](https://github.com/jaimejoaoferreirafilho-tech/strogosite/commit/e51f39d6404f9ff358afe5a1e3b63d29ebf73d5d), com separação visual de produtos acabados **na tela de carga**, não na de recebimentos.
- **Estado**: **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO** de todos os destinos e persistência.

### 17/11/2026 — Checklist de supermercado no celular
- **Solicitação**: ampliar leitura e área de toque em mobile.
- **Arquivo**: `lista-semanal/index.html`.
- **Histórico**: primeiro ajuste de CSS não resolveu, segundo ajuste mudou abertura para painel/tela ampla. A correção foi anunciada, mas não há confirmação posterior explícita de uso satisfatório.
- **Estado**: **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO**. Não presumir sucesso apenas pela presença do código.

### 17/11/2026 — Produtos acabados na compra avulsa CARGAJOI
- **Solicitação**: disponibilizar ESTROGONOFE DE FRANGO, DEFUMADO, CARNE, MIGNON, TRIFOLATI e TIKKA MASALA.
- **Mudança relatada**: vínculo de produtos já cadastrados ao fornecedor CARGAJOI no Supabase e prioridade na seleção de compra avulsa.
- **Arquivo**: `lista-semanal/index.html`; `stock_supplier_products`.
- **Estado**: **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO** de compra real e geração da previsão.

### 18/11/2026 — Documentação permanente do projeto
- **Solicitação**: criar `docs/CONTEXTO_DO_PROJETO.md`, `docs/HISTORICO_DE_ALTERACOES.md`, `docs/PENDENCIAS.md` e protocolo de continuidade.
- **Arquivos**: somente `docs/*.md`; nenhum arquivo da aplicação, esquema do banco ou configuração de produção alterado para esta tarefa.
- **Validação**: confirmar os três arquivos lendo-os novamente no GitHub. Commit(s) de criação podem ser separados pela API de conteúdos do GitHub.
- **Estado**: **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO** até releitura dos três arquivos.


### 18/11/2026 — Corrigir ID ausente na recuperação de sugestões canceladas
- **Solicitação**: BANDEJA ISOPOR RASA de Curitiba continuava visível após clicar na lixeira, confirmar e atualizar sem cache.
- **Causa comprovada no código**: `purchases()` consultava `stock_purchase_order_items` sem selecionar a coluna `id`, mas o filtro `ignoredRestored.has(it.id)` dependia dela. Logo, a sugestão cancelada ignorada continuava sendo reconstituída na interface.
- **Solução**: incluir `id` no `select` de `priorItems` em `lista-semanal/index.html`, sem mudar dados nem RPCs.
- **Commit**: [510d072](https://github.com/jaimejoaoferreirafilho-tech/strogosite/commit/510d072774d4c6bcee54f7a64db97dfc693aba79).
- **Testes**: sintaxe dos dois scripts validada; banco já apresentava `ignored=true` para a sugestão de contagem e a restaurada. Usuário confirmou em 18/11/2026 que, após a correção e atualização da página, **a BANDEJA ISOPOR RASA saiu da lista**. Teste E2E automatizado não executado.
- **Estado**: **VALIDADO PELO USUÁRIO** para a retirada da BANDEJA ISOPOR RASA da lista de sugestões de Curitiba. Não extrapolar essa confirmação para todas as sugestões.
- **Impacto**: corrige a identificação de itens restaurados em todos os pedidos cancelados; preserva dados de compras, histórico e estoque.


### 18/11/2026 — Compra avulsa: data em lote e origem de produtos acabados
- **Solicitação**: escolher uma única data para todos os itens da compra avulsa e evitar repetir CARGAJOI / FORNECEDOR JOI / Joinville para os seis estrogonofes/Tikka Masala.
- **Causa**: tela não tinha aplicação de data em lote e não preenchia os três campos de origem na inclusão dos produtos acabados.
- **Solução**: campo de data e botão `Aplicar data a todos` por loja; novos itens usam a data informada; defaults automáticos por nome exato dos seis produtos, buscando fornecedores cadastrados CARGAJOI e Joinville. A loja de destino não é alterada.
- **Arquivo**: `lista-semanal/index.html`.
- **Commit**: [cf1874a](https://github.com/jaimejoaoferreirafilho-tech/strogosite/commit/cf1874af49161f85e4ee0cd2202bcab4ff160800).
- **Testes**: os dois scripts passaram em validação sintática; sem teste de navegador autenticado ou confirmação do usuário.
- **Estado**: **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO**.
- **Próximo passo**: testar data em lote, preenchimento automático dos três campos, confirmação de compra e preservação da loja de destino.

### 18/11/2026 — Corrigir exclusão de itens avulsos e seleção em lote
- **Solicitação**: lixeira não removia itens da compra avulsa cadastrados na loja errada; adicionar seleção geral e exclusão dos selecionados.
- **Causa**: botão reutilizava RPC de ignorar sugestão de contagem, mas itens avulsos não têm `count_id`.
- **Solução**: remover itens avulsos apenas do array de rascunho, com confirmação; adicionar Selecionar todos, Desmarcar todos e Excluir selecionados na loja exibida; preservar fluxo de sugestões de contagem.
- **Arquivo**: `lista-semanal/index.html`.
- **Commit**: [82f298b](https://github.com/jaimejoaoferreirafilho-tech/strogosite/commit/82f298b22db78c397e65ad022db151810cd0800e).
- **Testes**: scripts sintaticamente válidos; sem teste de interface autenticada.
- **Estado**: **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO**. Não altera registros no banco.

### 18/11/2026 — Concluir despacho da carga na equipe Joinville
- **Solicitação**: botão para concluir carga após despacho e retirá-la dos afazeres da equipe JOI.
- **Solução**: por destino e data, exigir checklist 100% marcado; confirmar despacho; registrar por item em `stock_cargajoi_dispatched` via RPC `stock_cargajoi_dispatch`; filtrar despachados na RPC `stock_cargajoi_picking_list` sem mudar pedido ou recebimento.
- **Arquivos**: `lista-semanal/index.html`; banco: tabela nova e duas funções RPC (uma nova e uma atualizada).
- **Commit UI**: [8e3ed4c](https://github.com/jaimejoaoferreirafilho-tech/strogosite/commit/8e3ed4ca5226285d39c90501bf9e7692a8e74999).
- **Testes**: scripts sintaticamente válidos; consultas SQL confirmaram tabela e RPCs, sem despachos executados (`0` registros). **Sem teste autenticado de despacho**.
- **Estado**: **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO**.
- **Riscos/limites**: verificar permissão JOI, conclusão e sumiço do botão, persistência após recarga, e recebimento normal na loja.


### 18/11/2026 — Reenvio de compras FLN após cancelamento de recebimento
- **Problema**: mensagem `Compra sugerida sem contagem válida` ao reenviar produtos restaurados.
- **Causa verificada**: RPC de aprovação exige `count_id` para compra sugerida; pedidos cancelados FLN continham itens com referências de contagem nulas (inclusive estrogonofes).
- **Correção**: reenviar item restaurado sem contagem como `ad_hoc` apenas no payload, manter quantidade alterada no rascunho e ocultar item restaurado se houver compra ativa para produto/loja.
- **Arquivo**: `lista-semanal/index.html`.
- **Commits**: `f9108b1` e `9c59dc1`.
- **Testes**: validação sintática dos scripts. Sem teste autenticado de confirmação de compra, sem mutação de pedidos pelo assistente.
- **Status**: **IMPLEMENTADO — AGUARDANDO VALIDAÇÃO**. Confirmar envio e presença correta no recebimento sem duplicações.

## Modelo obrigatório para próximos registros
```md
### AAAA-MM-DD — Título
- Solicitação original:
- Sintoma/causa confirmada (se conhecida):
- Solução e escopo:
- Arquivos/tabelas alterados:
- Commit e deploy:
- Testes executados (separar sintaxe, banco, E2E e confirmação do usuário):
- Resultado observado:
- Estado: VALIDADO PELO USUÁRIO | IMPLEMENTADO — AGUARDANDO VALIDAÇÃO | NÃO RESOLVIDO | REVERTIDO | INVESTIGAR
- Possíveis impactos e próximo passo:
```
