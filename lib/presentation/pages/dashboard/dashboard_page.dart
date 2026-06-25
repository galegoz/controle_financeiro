import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_formatters.dart';
import '../../providers/settings_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/common/summary_card.dart';
import '../../widgets/common/budget_progress_bar.dart';
import '../../widgets/charts/income_expense_chart.dart';
import '../../widgets/transaction/transaction_list_item.dart';
import '../transaction/transaction_form_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.appName,
              style: theme.textTheme.headlineSmall,
            ),
            Text(
              AppFormatters.formatMonthYear(DateTime.now()),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        toolbarHeight: 68,
      ),
      body: Consumer2<TransactionProvider, SettingsProvider>(
        builder: (context, transactionProvider, settingsProvider, child) {
          if (transactionProvider.isLoading || settingsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final now = DateTime.now();
          final monthTransactions = transactionProvider.transactions.where((t) {
            return t.date.year == now.year && t.date.month == now.month;
          }).toList();

          final totalIncome = monthTransactions
              .where((t) => t.isIncome)
              .fold(0.0, (sum, t) => sum + t.amount);
          final totalExpense = monthTransactions
              .where((t) => t.isExpense)
              .fold(0.0, (sum, t) => sum + t.amount);
          final balance = totalIncome - totalExpense;
          final monthlyLimit = settingsProvider.monthlyLimit;

          final recentTransactions = monthTransactions.take(5).toList();

          return RefreshIndicator(
            onRefresh: () async {
              await transactionProvider.loadTransactions();
              await settingsProvider.loadSettings();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cards de saldo, receitas e despesas
                  SummaryCard(
                    title: AppStrings.balance,
                    value: AppFormatters.formatCurrency(balance),
                    icon: Icons.account_balance,
                    iconColor: balance >= 0 ? AppColors.income : AppColors.expense,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: AppStrings.totalIncome,
                          value: AppFormatters.formatCurrency(totalIncome),
                          icon: Icons.arrow_upward,
                          iconColor: AppColors.income,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SummaryCard(
                          title: AppStrings.totalExpense,
                          value: AppFormatters.formatCurrency(totalExpense),
                          icon: Icons.arrow_downward,
                          iconColor: AppColors.expense,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Barra de orçamento
                  BudgetProgressBar(
                    spent: totalExpense,
                    limit: monthlyLimit,
                  ),
                  const SizedBox(height: 8),

                  // Gráfico de pizza
                  IncomeExpenseChart(
                    totalIncome: totalIncome,
                    totalExpense: totalExpense,
                  ),
                  const SizedBox(height: 16),

                  // Últimas movimentações
                  if (recentTransactions.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Últimas Movimentações',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...recentTransactions.map(
                      (t) => TransactionListItem(
                        transaction: t,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TransactionFormPage(transaction: t),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

