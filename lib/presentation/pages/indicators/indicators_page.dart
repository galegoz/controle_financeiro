import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../providers/transaction_provider.dart';

class IndicatorsPage extends StatelessWidget {
  const IndicatorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.indicators),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactions = provider.transactions;
          final expenses = transactions.where((t) => t.isExpense).toList();
          final incomes = transactions.where((t) => t.isIncome).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gastos por Forma de Pagamento
                _buildSectionTitle(theme, AppStrings.byPaymentMethod, Icons.payment_outlined),
                const SizedBox(height: 12),
                _buildPaymentMethodChart(theme, expenses),
                const SizedBox(height: 24),

                // Total por Mês
                _buildSectionTitle(theme, AppStrings.byMonth, Icons.calendar_month_outlined),
                const SizedBox(height: 12),
                _buildMonthlyBarChart(theme, transactions),
                const SizedBox(height: 24),

                // Maior Despesa
                if (expenses.isNotEmpty) ...[
                  _buildSectionTitle(theme, AppStrings.biggestExpense, Icons.trending_down),
                  const SizedBox(height: 12),
                  _buildHighlightCard(theme, _getBiggest(expenses), AppColors.expense),
                  const SizedBox(height: 24),
                ],

                // Maior Receita
                if (incomes.isNotEmpty) ...[
                  _buildSectionTitle(theme, AppStrings.biggestIncome, Icons.trending_up),
                  const SizedBox(height: 12),
                  _buildHighlightCard(theme, _getBiggest(incomes), AppColors.income),
                  const SizedBox(height: 24),
                ],

                // Insights Automáticos
                _buildSectionTitle(theme, AppStrings.insights, Icons.lightbulb_outline),
                const SizedBox(height: 12),
                ..._buildInsights(theme, transactions),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: theme.textTheme.titleMedium),
      ],
    );
  }

  // ─── Gastos por Forma de Pagamento ────────────────────────
  Widget _buildPaymentMethodChart(ThemeData theme, List<TransactionEntity> expenses) {
    if (expenses.isEmpty) {
      return _buildEmptyState(theme, 'Sem despesas registradas');
    }

    final Map<String, double> totals = {};
    for (final e in expenses) {
      totals[e.paymentMethod] = (totals[e.paymentMethod] ?? 0) + e.amount;
    }

    final sorted = totals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final grandTotal = sorted.fold(0.0, (sum, e) => sum + e.value);

    final colors = [
      AppColors.primary,
      AppColors.accent,
      AppColors.budgetYellow,
      AppColors.budgetOrange,
      AppColors.expense,
      AppColors.income,
      AppColors.primaryDark,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 32,
                  sections: sorted.asMap().entries.map((entry) {
                    final i = entry.key;
                    final e = entry.value;
                    final pct = grandTotal > 0 ? (e.value / grandTotal * 100) : 0.0;
                    return PieChartSectionData(
                      value: e.value,
                      color: colors[i % colors.length],
                      radius: 36,
                      title: '${pct.toStringAsFixed(0)}%',
                      titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...sorted.asMap().entries.map((entry) {
              final i = entry.key;
              final e = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 12, height: 12,
                      decoration: BoxDecoration(
                        color: colors[i % colors.length],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e.key, style: theme.textTheme.bodySmall)),
                    Text(AppFormatters.formatCurrency(e.value), style: theme.textTheme.labelMedium),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ─── Total por Mês (Barras) ──────────────────────────────
  Widget _buildMonthlyBarChart(ThemeData theme, List<TransactionEntity> transactions) {
    if (transactions.isEmpty) {
      return _buildEmptyState(theme, 'Sem movimentações registradas');
    }

    final Map<String, double> incomeByMonth = {};
    final Map<String, double> expenseByMonth = {};

    for (final t in transactions) {
      final key = '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}';
      if (t.isIncome) {
        incomeByMonth[key] = (incomeByMonth[key] ?? 0) + t.amount;
      } else {
        expenseByMonth[key] = (expenseByMonth[key] ?? 0) + t.amount;
      }
    }

    final allMonths = {...incomeByMonth.keys, ...expenseByMonth.keys}.toList()..sort();
    final last6 = allMonths.length > 6 ? allMonths.sublist(allMonths.length - 6) : allMonths;

    if (last6.isEmpty) {
      return _buildEmptyState(theme, 'Sem dados para exibir');
    }

    final maxVal = last6.fold(0.0, (max, key) {
      final inc = incomeByMonth[key] ?? 0;
      final exp = expenseByMonth[key] ?? 0;
      final bigger = inc > exp ? inc : exp;
      return bigger > max ? bigger : max;
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              maxY: maxVal * 1.2,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final idx = value.toInt();
                      if (idx >= 0 && idx < last6.length) {
                        final parts = last6[idx].split('-');
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            '${parts[1]}/${parts[0].substring(2)}',
                            style: theme.textTheme.labelSmall,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: last6.asMap().entries.map((entry) {
                final i = entry.key;
                final key = entry.value;
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: incomeByMonth[key] ?? 0,
                      color: AppColors.income,
                      width: 10,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                    BarChartRodData(
                      toY: expenseByMonth[key] ?? 0,
                      color: AppColors.expense,
                      width: 10,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Maior Transação ─────────────────────────────────────
  TransactionEntity _getBiggest(List<TransactionEntity> list) {
    return list.reduce((a, b) => a.amount > b.amount ? a : b);
  }

  Widget _buildHighlightCard(ThemeData theme, TransactionEntity t, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                t.isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.description, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${t.paymentMethod} • ${AppFormatters.formatDate(t.date)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              AppFormatters.formatCurrency(t.amount),
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Insights Automáticos ────────────────────────────────
  List<Widget> _buildInsights(ThemeData theme, List<TransactionEntity> transactions) {
    final insights = <String>[];
    final now = DateTime.now();

    final thisMonth = transactions.where((t) => t.date.year == now.year && t.date.month == now.month).toList();
    final lastMonth = transactions.where((t) {
      final lm = DateTime(now.year, now.month - 1);
      return t.date.year == lm.year && t.date.month == lm.month;
    }).toList();

    final thisExpense = thisMonth.where((t) => t.isExpense).fold(0.0, (s, t) => s + t.amount);
    final lastExpense = lastMonth.where((t) => t.isExpense).fold(0.0, (s, t) => s + t.amount);

    if (lastExpense > 0 && thisExpense > 0) {
      final diff = ((thisExpense - lastExpense) / lastExpense * 100).abs();
      if (thisExpense > lastExpense) {
        insights.add('📈 Você gastou ${diff.toStringAsFixed(0)}% a mais que no mês anterior.');
      } else {
        insights.add('📉 Você gastou ${diff.toStringAsFixed(0)}% a menos que no mês anterior.');
      }
    }

    // Forma de pagamento mais usada
    final Map<String, int> methodCount = {};
    for (final t in thisMonth) {
      methodCount[t.paymentMethod] = (methodCount[t.paymentMethod] ?? 0) + 1;
    }
    if (methodCount.isNotEmpty) {
      final sorted = methodCount.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
      final top = sorted.first;
      final pct = (top.value / thisMonth.length * 100).toStringAsFixed(0);
      insights.add('💳 ${top.key} representa $pct% das suas movimentações este mês.');
    }

    // Maior despesa do mês
    final monthExpenses = thisMonth.where((t) => t.isExpense).toList();
    if (monthExpenses.isNotEmpty) {
      final biggest = _getBiggest(monthExpenses);
      insights.add('💰 Sua maior despesa este mês foi ${AppFormatters.formatCurrency(biggest.amount)} (${biggest.description}).');
    }

    if (insights.isEmpty) {
      return [_buildEmptyState(theme, 'Adicione movimentações para ver insights.')];
    }

    return insights.map((text) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(text, style: theme.textTheme.bodyMedium),
              ),
            ],
          ),
        ),
      ),
    )).toList();
  }

  Widget _buildEmptyState(ThemeData theme, String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(128),
            ),
          ),
        ),
      ),
    );
  }
}
