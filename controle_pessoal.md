# Aplicativo de Controle Financeiro Pessoal

Desenvolva um aplicativo de controle financeiro pessoal com foco em simplicidade, praticidade e visualização rápida da saúde financeira do usuário.

## Objetivo

Permitir que o usuário registre receitas e despesas de forma rápida e acompanhe sua situação financeira mensal através de indicadores visuais e relatórios exportáveis.

## Funcionalidades Principais

### 1. Dashboard (Tela Inicial)

A tela inicial deve exibir:

* Saldo atual (Receitas - Despesas)
* Total de receitas do mês
* Total de despesas do mês
* Percentual do orçamento utilizado
* Gráfico simples demonstrando receitas e despesas
* Indicador visual do limite de gastos mensal

### 2. Controle de Orçamento Mensal

O usuário deve poder configurar um valor máximo sugerido para gastos no mês.

Exemplo:

* Limite mensal: R$ 3.000,00

Comportamento visual:

* Até 70% do limite: Cor verde
* Entre 70% e 90%: Cor amarela
* Entre 90% e 100%: Cor laranja
* Acima de 100%: Cor vermelha

Exibir mensagem de alerta quando o limite for ultrapassado:

"Você ultrapassou seu orçamento mensal em R$ X."

### 3. Cadastro de Movimentações

Permitir o lançamento de receitas e despesas através de um formulário simples contendo:

Campos obrigatórios:

* Tipo:

  * Receita
  * Despesa

* Data

* Descrição

* Valor

* Forma de pagamento

### Formas de pagamento

* Dinheiro
* PIX
* Cartão de Débito
* Cartão de Crédito
* Transferência Bancária
* Boleto
* Outros

### Funcionalidades Extras do Cadastro

* Edição de lançamentos
* Exclusão de lançamentos
* Pesquisa por descrição
* Filtro por período
* Filtro por tipo

### 4. Histórico Financeiro

Listar todas as movimentações em ordem decrescente de data.

Exibir:

* Data
* Descrição
* Valor
* Tipo
* Forma de pagamento

Diferenciação visual:

* Receitas em verde
* Despesas em vermelho

### 5. Relatórios e Exportação

Criar uma tela de exportação contendo:

Filtros:

* Data Inicial
* Data Final

Opções de exportação:

* Excel (.xlsx)
* CSV
* PDF

O relatório deve conter:

* Período selecionado
* Total de receitas
* Total de despesas
* Saldo do período
* Lista detalhada das movimentações

### 6. Indicadores Financeiros

Exibir:

* Total gasto por forma de pagamento
* Total gasto por mês
* Evolução do saldo mensal
* Maior despesa do período
* Maior receita do período

## Requisitos de Interface

### Design

* Interface moderna e minimalista
* Layout responsivo
* Tema claro e escuro
* Ícones intuitivos
* Navegação simples

### Menu

* Dashboard
* Nova Movimentação
* Histórico
* Relatórios
* Configurações

## Configurações

Permitir configurar:

* Limite mensal de gastos
* Moeda (padrão Real - BRL)
* Tema claro ou escuro
* Backup dos dados

## Armazenamento

* Salvar os dados localmente no dispositivo
* Possibilidade futura de sincronização em nuvem

## Tecnologias Sugeridas

Frontend:

* Flutter

Banco de Dados:

* SQLite

Arquitetura:

* MVVM ou Clean Architecture

## Diferencial

Adicionar uma seção de insights financeiros automáticos, por exemplo:

* "Você gastou 15% a mais que no mês anterior."
* "O PIX representa 60% dos seus pagamentos."
* "Sua maior despesa este mês foi R$ X."

O objetivo é que o aplicativo seja extremamente simples para registrar movimentações, mas forneça uma visão clara e inteligente das finanças pessoais.
