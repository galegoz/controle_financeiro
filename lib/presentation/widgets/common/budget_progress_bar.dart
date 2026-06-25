import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class BudgetProgressBar extends StatelessWidget {
  final double spent;
  final double limit;

  const BudgetProgressBar({
    super.key,
    required this.spent,
    required this.limit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = limit > 0 ? (spent / limit) : 0.0;
    final clampedPercentage = percentage.clamp(0.0, 1.5);
    final displayPercentage = (percentage * 100).clamp(0.0, 999.9);

    final barColor = _getColor(percentage);
    final exceeded = percentage > 1.0;
    final exceededAmount = spent - limit;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: barColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.account_balance_wallet_outlined, color: barColor, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Orçamento Mensal',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: barColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${displayPercentage.toStringAsFixed(0)}%',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: barColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Barra de progresso
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: clampedPercentage > 1.0 ? 1.0 : clampedPercentage,
                backgroundColor: barColor.withAlpha(30),
                color: barColor,
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 8),

            // Alerta se excedido
            if (exceeded)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.budgetRed.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.budgetRed.withAlpha(60)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: AppColors.budgetRed, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Você ultrapassou seu orçamento mensal em R\$ ${exceededAmount.toStringAsFixed(2)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.budgetRed,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getColor(double percentage) {
    if (percentage > 1.0) return AppColors.budgetRed;
    if (percentage > 0.9) return AppColors.budgetOrange;
    if (percentage > 0.7) return AppColors.budgetYellow;
    return AppColors.budgetGreen;
  }
}
