# Plano de Implementação: Aplicativo de Controle Financeiro Pessoal

Este documento detalha o plano de desenvolvimento em fases para o aplicativo de controle financeiro pessoal utilizando Flutter, seguindo a especificação fornecida. O foco será em Clean Architecture / MVVM e armazenamento local com SQLite.

## Decisões Aprovadas

> [!NOTE]  
> - **Bibliotecas de Exportação**: Nenhuma preferência específica. Utilizaremos pacotes padrões da comunidade (ex: `pdf`, `excel`).
> - **Backup**: O backup será realizado exportando os dados em formato PDF.

## Proposed Changes

O desenvolvimento será dividido nas seguintes fases e componentes:

### Fase 1: Configuração Inicial e Arquitetura

*   [NEW] Criar projeto Flutter.
*   [NEW] Configurar estrutura de pastas baseada em Clean Architecture ou MVVM (core, data, domain, presentation).
*   [NEW] Configurar dependências principais (ex: `sqflite`, `provider` ou `bloc`/`riverpod` para gerência de estado, `google_fonts`, `fl_chart` para gráficos).
*   [NEW] Implementar o design system básico (Temas Claro/Escuro, cores primárias, tipografia).

### Fase 2: Banco de Dados e Modelagem (Local Storage)

*   [NEW] Modelar a entidade `Transaction` (Movimentação) com campos: id, type (receita/despesa), date, description, amount, paymentMethod.
*   [NEW] Criar tabelas e helpers do SQLite (`DatabaseHelper`).
*   [NEW] Implementar repositórios para operações CRUD de movimentações.
*   [NEW] Modelar entidade e tabela para as Configurações (`Settings`), incluindo limite mensal e tema.

### Fase 3: Cadastro e Histórico de Movimentações

*   [NEW] Criar tela e formulário de "Nova Movimentação" com validações.
*   [NEW] Implementar lógica de salvar, editar e excluir movimentações.
*   [NEW] Criar tela de "Histórico Financeiro".
*   [NEW] Adicionar filtros e ordenação na tela de Histórico (por data, tipo, pesquisa de texto).
*   [NEW] Diferenciação visual na lista (receitas em verde, despesas em vermelho).

### Fase 4: Dashboard e Controle de Orçamento (Tela Inicial)

*   [NEW] Implementar cálculo de saldo, receitas do mês e despesas do mês.
*   [NEW] Criar componente visual para o controle de limite mensal (barra de progresso com mudança de cor: verde < 70%, amarelo < 90%, laranja < 100%, vermelho > 100%).
*   [NEW] Adicionar gráficos (`fl_chart`) para visualizar receitas vs despesas.
*   [NEW] Integrar lógica de alertas (Ex: "Você ultrapassou seu orçamento...").

### Fase 5: Relatórios e Indicadores

*   [NEW] Desenvolver tela de Indicadores Financeiros (Total por forma de pagamento, total por mês, maior despesa/receita).
*   [NEW] Criar lógica de Insights Automáticos baseados nos dados locais.
*   [NEW] Desenvolver funcionalidade de Relatórios e Exportação (CSV, XLSX, PDF) utilizando pacotes específicos.

### Fase 6: Configurações e Refinamento

*   [NEW] Desenvolver tela de Configurações (Ajuste de limite mensal, troca de tema Claro/Escuro, formato de Moeda).
*   [NEW] Implementar funcionalidade de Backup de Dados (exportação de PDF).
*   [NEW] Refinamento de UI/UX, animações, ícones e responsividade.

## Verification Plan

### Automated Tests
*   Testes unitários para as funções de cálculo financeiro (saldo, limite, agrupamentos por mês/forma de pagamento).
*   Testes unitários para o repositório SQLite (Mock).

### Manual Verification
*   Testar fluxo completo de inserção, edição e remoção de receitas e despesas.
*   Verificar a mudança de estado e cor no Dashboard ao exceder os limites configurados.
*   Alternar entre modo claro e escuro para verificar a consistência visual.
*   Gerar e validar os arquivos exportados (CSV, Excel e PDF).
