
**[REGRA/CÓDIGO — 18/11/2026]** Compras sugeridas: cada categoria possui seletores gerais de origem CARGAJOI e fornecedor JOI. Eles atualizam somente os itens da categoria cujo fornecedor logístico é CARGAJOI, preservando edição individual. Selecionar fornecedor aplica origem FORNECEDOR_JOINVILLE; supermercado e estoque disponível dispensam fornecedor comercial. As escolhas permanecem no rascunho até confirmação da compra. Commit `cfc6782`; validação funcional pendente.


**[CADASTROS — 18/11/2026]** VINAGRE (Mercearia) e PAPEL HIGIÊNICO (Descartáveis) integram a lista semanal de contagem de todas as unidades, ambos em UN, sem pedido de compra imediato. PIMENTA DO REINO foi ocultada das contagens JOI/JAR/FLN/CWB por `stock_count_visibility`, preservando cadastro e histórico; PIMENTA EM GRÃO permanece visível. Alteração direta no Supabase, sem mudança de código.


**[REGRA/CÓDIGO/BD — 18/11/2026]** Origem `ESTOQUE_JOINVILLE` significa produto já disponível em Joinville, sem nova compra/encomenda, mas ainda incluído na separação CARGAJOI. Campo `stock_purchase_order_items.cargajoi_purchase_source` aceita essa opção; RPC `stock_set_cargajoi_item_source` foi ajustada, mantendo restrição de admin. Tela `lista-semanal/index.html` permite selecionar a origem e exibe no grupo de produção/estoque disponível. Commit `3303b11`.


**[REGRA — 18/11/2026]** Os cinco ESTROGONOFES e TIKKA MASALA são produção própria da cozinha Joinville. Nas compras CARGAJOI não devem exigir fornecedor comercial nem entrar em lista de supermercado/encomendas; devem continuar na separação de carga. A interface os identifica pelo cadastro de produto e os apresenta em grupo Produção própria. Commit `a4589a7`; validação funcional pendente.


**[REGRA — 18/11/2026]** CARGAJOI indica transporte/separação, não forma de aquisição. Cada item deve ter origem SUPERMERCADO ou FORNECEDOR_JOINVILLE com fornecedor real; compras de supermercado não exigem identificar Fort/Giassi. As listas de aquisição devem permanecer separadas, e todos os itens seguem na separação da carga. Classificação deve poder variar por compra, preservando padrões de cadastro. Commit `16be314b`, ajuste `b15d95e`. Não atribuir origem a pedidos existentes por suposição.


**[REGRA/CÓDIGO — 18/11/2026]** Na seção Compras sugeridas pelas lojas, o botão `Excluir selecionados` ignora em lote as sugestões marcadas, respeitando filtro de loja. Usa RPC `stock_ignore_restored_item` para recuperadas e `stock_ignore_purchase_suggestion` para contagens, com confirmação, processamento individual e relatório de falhas. Não apaga cadastros, pedidos confirmados nem estoque. Commit `626a68c`; validação funcional pendente.


**[REGRA/CÓDIGO — 18/11/2026]** Após envio confirmado de contagem semanal (`stock_counts.status='enviado'`), o login da loja deve ocultar a lista preenchida e os botões de edição, exibindo confirmação clara de sucesso, inclusive após recarregar. Isso é somente apresentação: contagem e itens permanecem preservados no Supabase para histórico e sugestões de compra. Commit `5a2190a`; validação de interface pendente.


**[REGRA — 18/11/2026]** Toda compra com fornecedor CARGAJOI usa obrigatoriamente origem `FORNECEDOR_JOINVILLE` (exibida como FORNECEDOR JOI) e fornecedor de origem cadastrado `JOINVILLE`, inclusive sugestões restauradas. Destino permanece independente. Interface bloqueia esses campos. Commit `74f9444`; validação no navegador pendente.

# CONTEXTO DO PROJETO — CASA DO ESTROGONOFE
Atualizado em 18/11/2026. Repositório: `jaimejoaoferreirafilho-tech/strogosite`, branch `main`.

## INSTRUÇÕES PARA NOVAS CONVERSAS DO CHATGPT
1. **Antes de qualquer alteração**, ler integralmente `docs/CONTEXTO_DO_PROJETO.md`, `docs/HISTORICO_DE_ALTERACOES.md` e `docs/PENDENCIAS.md`.
2. Consultar **o código atual** da branch `main` no GitHub, nunca presumir que o resumo documentado seja a implementação vigente.
3. Inspecionar os commits recentes e verificar se houve reversões; conferir SHA do arquivo e commit antes de gravar.
4. Consultar a implantação **de produção** do projeto `strogosite` na Vercel, seu estado e, quando disponível, o commit publicado.
5. Consultar somente a estrutura e os dados **relevantes** do Supabase, com queries de leitura inicialmente.
6. Retomar prioridades e pendências em `docs/PENDENCIAS.md` e confirmar qual tela/URL o usuário está vendo.
7. Não repetir tentativas que falharam sem diagnosticar a causa, conferir o arquivo certo e testar sintaxe e comportamento.
8. Preservar funcionalidades, autenticação, dados e histórico; não tocar em finanças/contas a pagar no Bling.
9. Não executar operações destrutivas em banco, cadastros ou produção sem autorização explícita. Não expor senhas, chaves, dados pessoais nem tokens.
10. Atualizar estes três documentos após cada alteração relevante, registrando resultados **observados** e o próximo passo. Documentação não é prova de funcionamento.
11. Para alteração de UI: confirmar tela real, modificar o menor trecho possível, verificar sintaxe dos scripts (inclusive módulos), revisar diff, verificar Vercel e pedir teste funcional quando não houver teste autenticado. **READY não significa funcionalidade validada**.
12. No encerramento de uma sessão longa, atualizar `PENDENCIAS.md` antes de prosseguir.

## Legenda de evidência
- **[CÓDIGO]**: observado nos arquivos atuais do GitHub em 18/11/2026.
- **[BANCO]**: confirmado em consultas somente de leitura ao Supabase.
- **[REGRA]**: definido pelo usuário em conversas; pode exigir confirmação no código.
- **[RELATO]**: comportamento confirmado ou relatado pelo usuário; não equivale a teste automatizado.
- **[A VERIFICAR]**: não comprovado; nunca presumir que já esteja implementado.

## Objetivo e infraestrutura
**[REGRA]** Portal operacional para quatro unidades: Joinville (JOI), Jaraguá do Sul (JAR), Florianópolis (FLN) e Curitiba (CWB), integrando contagem periódica, compras, cotações, previsões de recebimento, separação de cargas, estoque, fichas técnicas e ordens de produção. Substituir listas manuais, reduzir erros de unidade e preservar rastreabilidade.

**[CÓDIGO]** Repositório `strogosite` contém páginas HTML/JavaScript com cliente `@supabase/supabase-js`. Arquivos verificados:
- `index.html`: site público institucional, distinto do portal operacional.
- `lista-semanal/index.html`: contagens, compras sugeridas/avulsas, cadastro, movimentações, fornecedores, listas de supermercado e CARGAJOI, administração de acessos e telas de separação.
- `op/index.html`: recebimentos, produção, fichas técnicas e estoque.
- `equipe/index.html`: área de equipe/intermitentes; lógica distinta do portal de estoque.
Outros caminhos do repositório devem ser inventariados antes de alterações; não pressupor que esta lista seja exaustiva. `README.md` e `vercel.json` não foram localizados nos caminhos testados.

**[CÓDIGO/BANCO]** Backend Supabase do projeto Casa do Estrogonofe, projeto identificado por ref `xbpzjvxocnnqefajsnto`, região `sa-east-1`, consultado como `ACTIVE_HEALTHY` em 18/11/2026. Não inserir credenciais na documentação. Há autenticação por Supabase e funções RPC `stock_*`.

**[VERCEL]** Projeto `strogosite`, domínio `www.casadoestrogonofe.com.br` e `casadoestrogonofe.com.br`; última implantação de produção consultada antes da criação da documentação: `dpl_D9sBfNJzYb7UbY6KjwvWDACEwkQ2`, `READY`. Verificar novamente em novos chats: documentação cria novos commits e pode acionar deploy sem alterar aplicação.

**[REGRA/A VERIFICAR]** Resend para e-mails de confirmações e notificações; não foi localizada uma implementação Resend nos três arquivos operacionais examinados. Verificar Edge Functions, configuração externa e serviços conectados antes de descrever comportamento. Não acessar ou publicar segredos.

## Usuários e permissões
**[REGRA]** Administração pode confirmar/editar compras, realizar entradas justificadas e cancelar OPs; não deve executar contagem semanal. Equipes das lojas acessam contagem, previsões de recebimento e OPs conforme permissão; saldos de estoque não devem ficar expostos às lojas. A equipe de Joinville separa CARGAJOI. Lideranças possuem acesso próprio à área OP.

**[CÓDIGO]** A página Lista Semanal verifica `admin()` e `profile.unit_code` para mostrar botões de carga apenas a admin/JOI; botões para JAR/CWB/FLN dependem de linhas retornadas por `stock_cargajoi_picking_list`. A página OP distingue autenticação de equipe e liderança. **[A VERIFICAR]** Revisar políticas RLS, grants, permissões efetivas e papéis antes de alterações de acesso; a presença de controle na interface não garante isolamento no banco.

## Fluxos operacionais e dependências
### Contagens e compras
**[REGRA]** Contagens duas vezes por semana, segunda e quinta após almoço; todos os itens devem ter número (zero permitido); histórico de contagem imutável. Unidades e embalagens por produto são explícitas; mínimos podem ser decimais. As sugestões dependem de contagens e mínimos. Administração escolhe fornecedores, quantidades, datas de entrega e confirma compra. Itens ignorados não devem reaparecer indevidamente.

**[CÓDIGO/BANCO]** `stock_counts`, `stock_count_items`, `stock_targets`, `stock_purchase_suggestion_ignored`, `stock_purchase_orders`, `stock_purchase_order_items`, `stock_suppliers`, `stock_supplier_products`. `lista-semanal/index.html` contém `purchases()`, compra avulsa, fluxo de sugestões restauradas de pedidos cancelados e funções de confirmação/ignorados. RPCs presentes: `stock_approve_suggested_purchases`, `stock_ignore_purchase_suggestion`, `stock_cancel_pending_purchase`, `stock_ignore_restored_item`, `stock_ignored_restored_suggestions`.

**[REGRA]** Compras avulsas podem ocorrer sem contagem; fornecedor CARGAJOI usado para abastecer outras lojas. Produtos em cadastros sempre em **MAIÚSCULAS**. Padronizar insumos produtivos em KG conforme fichas técnicas, mas respeitar unidade de compra/embalagem (UN, FD, CX etc.) e conversões efetivamente cadastradas.


**[REGRA/CÓDIGO — 18/11/2026]** Na compra avulsa, o administrador pode escolher uma data e aplicar a todos os itens da loja selecionada. Para os seis produtos acabados (ESTROGONOFE DE FRANGO, DEFUMADO, CARNE, MIGNON, TRIFOLATI e TIKKA MASALA), os campos são preenchidos automaticamente com fornecedor CARGAJOI, origem FORNECEDOR JOI e fornecedor de origem Joinville (cadastro de fornecedor), mantendo a loja de destino escolhida. Implementação em `lista-semanal/index.html`, commit `cf1874a`. **[A VERIFICAR]** Funcionamento completo no navegador e confirmação de compra.

**[REGRA/CÓDIGO — 18/11/2026]** Na compra avulsa, lixeira individual e ação em lote removem apenas itens em preparação da unidade exibida, sem chamadas de exclusão ao banco. Botões Selecionar todos, Desmarcar todos e Excluir selecionados operam sobre itens da loja selecionada. Não afetam pedidos confirmados nem sugestões de contagem. Commit `82f298b`; confirmação em navegador pendente.

### Listas supermercado e fornecedores
**[REGRA]** Manter lista consolidada de supermercado e listas por fornecedores de Joinville (ex.: Mercado das Embalagens). Não criar lista geral redundante de Joinville. Buscar itens de compras JOI com fornecedores **Fort** e **Giassi** e agregar produtos idênticos para compra e distribuição, mantendo destino/data. Classificação da origem da CARGAJOI ocorre na confirmação da compra, sem tela duplicada de classificação.

**[CÓDIGO]** `renderCargaJoi()` em `lista-semanal/index.html` monta consolidações e permite marcar `Já comprei` por produto; `stock_local_purchase_checks`, `stock_local_purchase_checked_ids` e `stock_local_purchase_mark` persistem marcações. **[A VERIFICAR]** Testar fluxo real de agrupamento, exclusão da lista após marcação e integridade das datas/destinos. Marcar compra não deve registrar entrada em estoque.

### CARGAJOI e recebimentos
**[REGRA]** A equipe de JOI separa as cargas para JAR, CWB e FLN. Botões `Carga Jaraguá`, `Carga Curitiba`, `Carga Floripa` devem aparecer apenas havendo compras CARGAJOI correspondentes. Checklist individual, persistência de separação e data prevista de recebimento.

**[CÓDIGO/BANCO]** `renderCargaScreen()` e `refreshCargaButtons()` em `lista-semanal/index.html`; RPCs `stock_cargajoi_picking_list` e `stock_cargajoi_picking_set`; tabela `stock_cargajoi_picking`.

**[REGRA]** Na **tela Recebimento** de `op/index.html`, dentro do mesmo pedido CARGAJOI, exibir primeiro grupo `ESTROGONOFES E TIKKA MASALA` (ESTROGONOFE DE FRANGO, ESTROGONOFE DEFUMADO, ESTROGONOFE DE CARNE, ESTROGONOFE DE MIGNON, ESTROGONOFE TRIFOLATI, TIKKA MASALA) e segundo grupo `DEMAIS INGREDIENTES E PRODUTOS`. Não separar em pedidos distintos nem alterar as quantidades recebidas.

**[CÓDIGO/RELATO]** Commit `5f09c21` alterou `op/index.html` para ordenar e inserir cabeçalhos dentro de `renderOrders()`; scripts passaram em validação sintática. Usuário confirmou `Ficou ótimo` em 18/11/2026. **[A VERIFICAR]** Não há teste E2E automatizado comprovado; validar com novos pedidos e diferentes lojas.

**[CÓDIGO]** Recebimento de pedido utiliza `stock_receive_purchase` e campos de quantidade recebida; confirmações alimentam movimentações de estoque. Histórico de recebimento e diferenças entre previsto e recebido aparecem em `op/index.html`. Não confundir tela de separação de carga em `lista-semanal/` com tela de recebimento em `op/?area=recebimento`.

**[CÓDIGO/BANCO — 18/11/2026]** A equipe JOI pode concluir despacho CARGAJOI por destino (JAR/CWB/FLN) e data prevista, apenas após todos os itens estarem marcados como separados. O botão `Concluir e despachar carga` chama `stock_cargajoi_dispatch`; a tabela `stock_cargajoi_dispatched` registra cada item e o responsável/horário, e `stock_cargajoi_picking_list` deixa de listar itens despachados. A compra e o recebimento no destino não são alterados. Commit de UI `8e3ed4c`; validação autenticada pendente. Itens novos posteriores permanecem disponíveis, mesmo para mesma data.

### Fichas técnicas, OP e estoque
**[REGRA]** OPs por receitas, rendimentos previstos e reais, estados planejada/em andamento/finalizada/cancelada; controle de insumos, produtos transformados, embalagens, perdas, rendimento e tempo. Produção deve verificar disponibilidade de estoque antes de baixar insumos; cancelamento deve respeitar reversão de movimentos. Lojas não veem saldos; admin gerencia ajustes manuais com motivo.

**[CÓDIGO/BANCO]** Tabelas `stock_products`, `stock_product_kg_conversions`, `stock_recipes`, `stock_recipe_items`, `stock_production_orders`, `stock_movements`, `stock_manual_adjustments`. RPCs incluem `stock_create_recipe_with_output`, `stock_edit_recipe`, `stock_check_production_supply`, `stock_prepare_production_order`, `stock_start_production`, `stock_finish_production`, `stock_cancel_production`, `stock_register_manual_adjustment`. `op/index.html` contém telas de receitas e OPs. **[A VERIFICAR]** Verificar fórmulas de rendimento e reversões caso a caso; não presumir testes concluídos.

**[REGRA]** Exemplos de decisões de ficha técnica informadas em conversas anteriores (verificar cadastro atual antes de usar): MOLHO ESTROGONOFE com rendimento 38 KG e água removida; CEBOLA BATIDA rendimento 0,653 KG por KG com casca; FRANGO NAT fator de cocção 0,81; OP de produto final usa MOLHO PRONTO + PROTEÍNA PRONTA + CHAMPIGNON + POUCH; arroz cozido rendimento aproximado 3x. Embalagens podem ser UN; ingredientes padronizados em KG, incluindo líquidos após conversão apropriada.

## Restrições e cautelas
- **[REGRA]** Não tocar contas a pagar, caixa, conciliação bancária ou repasses iFood já geridos manualmente no Bling. Este portal é projeto operacional distinto; integração Bling/iFood não foi confirmada nestes arquivos.
- Não duplicar produtos (especialmente `OVOS` e produtos acabados), não apagar registros históricos, não modificar saldos nem movimentações sem autorização.
- Diferenciar **sugestão ignorada**, **pedido cancelado**, **compra confirmada**, **carga separada** e **recebimento efetivado**: são estados e consequências distintos.
- Não confundir mudança visual com mudança de banco. Usar mudanças pequenas e revisão de diff; nunca afirmar `resolvido` só por commit/READY.
- Não gravar segredos, identificadores pessoais de funcionários, contatos privados ou credenciais.

## Protocolo de testes e manutenção
1. Ler documentação, recuperar SHA atual do arquivo e histórico dos commits.
2. Reproduzir a falha no caminho e perfil corretos; distinguir `/lista-semanal/` de `/op/?area=recebimento`.
3. Conferir dados reais relevantes com SQL **somente de leitura** e RPCs, sem modificar dados produtivos durante diagnóstico.
4. Revisar escopo, efeitos e autorização; preparar reversão de arquivo.
5. Validar JavaScript e fluxo de UI, especialmente concatenação de HTML em `renderOrders()` (tentativas anteriores quebraram sintaxe e acesso).
6. Publicar somente alteração revisada; verificar status do deploy e executar teste funcional quando possível.
7. Registrar em `HISTORICO_DE_ALTERACOES.md` o que de fato foi testado; em `PENDENCIAS.md` o que permanece.
8. Atualizar CONTEXTO para decisões novas; manter documentação sincronizada no mesmo commit ou no commit de documentação imediatamente seguinte.

## Serviços e pontos ainda não recuperados
**[A VERIFICAR]** Inventário completo do repositório e demais funções; implantação exata do commit pós-documentação; implementação de Resend/Edge Functions; testes automatizados e observabilidade; matriz completa de RLS; regras atuais de todas as fichas técnicas; validação real do fluxo de `Já comprei`, listas de fornecedores e exclusão de sugestões recuperadas. Consultar `PENDENCIAS.md` para prioridade e próximo passo.
