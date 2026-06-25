class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'Controle Pessoal';
  static const String appVersion = '1.0.0';

  // Menu / Navegação
  static const String navDashboard = 'Dashboard';
  static const String navNewTransaction = 'Nova Movimentação';
  static const String navHistory = 'Histórico';
  static const String navReports = 'Relatórios';
  static const String navSettings = 'Configurações';
  static const String navIndicators = 'Indicadores';

  // Tipos de Transação
  static const String income = 'Receita';
  static const String expense = 'Despesa';

  // Formas de Pagamento
  static const String paymentCash = 'Dinheiro';
  static const String paymentPix = 'PIX';
  static const String paymentDebit = 'Cartão de Débito';
  static const String paymentCredit = 'Cartão de Crédito';
  static const String paymentTransfer = 'Transferência Bancária';
  static const String paymentBoleto = 'Boleto';
  static const String paymentOther = 'Outros';

  static const List<String> paymentMethods = [
    paymentCash,
    paymentPix,
    paymentDebit,
    paymentCredit,
    paymentTransfer,
    paymentBoleto,
    paymentOther,
  ];

  // Dashboard
  static const String balance = 'Saldo Atual';
  static const String totalIncome = 'Total de Receitas';
  static const String totalExpense = 'Total de Despesas';
  static const String monthlyBudget = 'Orçamento Mensal';
  static const String budgetUsed = 'do orçamento utilizado';
  static const String budgetExceeded = 'Você ultrapassou seu orçamento mensal em ';
  static const String incomeVsExpense = 'Receitas vs Despesas';
  static const String insights = 'Insights Financeiros';

  // Histórico
  static const String history = 'Histórico Financeiro';
  static const String searchHint = 'Buscar por descrição...';
  static const String noTransactions = 'Nenhuma movimentação encontrada';
  static const String filterByType = 'Filtrar por tipo';
  static const String filterByPeriod = 'Filtrar por período';
  static const String all = 'Todos';

  // Formulário
  static const String newTransaction = 'Nova Movimentação';
  static const String editTransaction = 'Editar Movimentação';
  static const String fieldType = 'Tipo *';
  static const String fieldDate = 'Data *';
  static const String fieldDescription = 'Descrição *';
  static const String fieldAmount = 'Valor *';
  static const String fieldPaymentMethod = 'Forma de Pagamento *';
  static const String save = 'Salvar';
  static const String cancel = 'Cancelar';
  static const String delete = 'Excluir';
  static const String edit = 'Editar';
  static const String confirmDelete = 'Confirmar Exclusão';
  static const String confirmDeleteMsg = 'Deseja realmente excluir esta movimentação?';

  // Validações
  static const String required = 'Campo obrigatório';
  static const String invalidAmount = 'Informe um valor válido';

  // Relatórios
  static const String reports = 'Relatórios';
  static const String exportPdf = 'Exportar PDF';
  static const String exportExcel = 'Exportar Excel';
  static const String exportCsv = 'Exportar CSV';
  static const String startDate = 'Data Inicial';
  static const String endDate = 'Data Final';
  static const String period = 'Período';
  static const String selectDate = 'Selecionar data';

  // Indicadores
  static const String indicators = 'Indicadores';
  static const String byPaymentMethod = 'Gastos por Forma de Pagamento';
  static const String byMonth = 'Total por Mês';
  static const String balanceEvolution = 'Evolução do Saldo';
  static const String biggestExpense = 'Maior Despesa';
  static const String biggestIncome = 'Maior Receita';

  // Configurações
  static const String settings = 'Configurações';
  static const String monthlyLimit = 'Limite Mensal de Gastos';
  static const String currency = 'Moeda';
  static const String theme = 'Tema';
  static const String themeLight = 'Claro';
  static const String themeDark = 'Escuro';
  static const String themeSystem = 'Sistema';
  static const String backup = 'Backup dos Dados';
  static const String backupExport = 'Exportar Backup (PDF)';

  // Erros
  static const String genericError = 'Ocorreu um erro. Tente novamente.';
  static const String dbError = 'Erro ao acessar o banco de dados.';
}
