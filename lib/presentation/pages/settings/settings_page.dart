import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_formatters.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/transaction_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: Consumer3<SettingsProvider, ThemeProvider, TransactionProvider>(
        builder: (context, settingsProvider, themeProvider, transactionProvider, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ─── Limite Mensal ────────────────────────
              _buildSectionHeader(theme, 'Orçamento', Icons.account_balance_wallet_outlined),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.monthlyLimit, style: theme.textTheme.titleSmall),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              AppFormatters.formatCurrency(settingsProvider.monthlyLimit),
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _editMonthlyLimit(context, settingsProvider),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ─── Aparência ───────────────────────────
              _buildSectionHeader(theme, 'Aparência', Icons.palette_outlined),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment(
                            value: ThemeMode.light,
                            label: Text('Claro'),
                            icon: Icon(Icons.light_mode_outlined),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            label: Text('Escuro'),
                            icon: Icon(Icons.dark_mode_outlined),
                          ),
                          ButtonSegment(
                            value: ThemeMode.system,
                            label: Text('Sistema'),
                            icon: Icon(Icons.settings_brightness_outlined),
                          ),
                        ],
                        selected: {themeProvider.themeMode},
                        onSelectionChanged: (Set<ThemeMode> newSelection) {
                          themeProvider.setThemeMode(newSelection.first);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ─── Moeda ──────────────────────────────
              _buildSectionHeader(theme, 'Moeda', Icons.attach_money_outlined),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.monetization_on_outlined),
                  title: const Text(AppStrings.currency),
                  subtitle: Text(settingsProvider.currency),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _editCurrency(context, settingsProvider),
                ),
              ),
              const SizedBox(height: 24),

              // ─── Backup ─────────────────────────────
              _buildSectionHeader(theme, 'Dados', Icons.storage_outlined),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: Icon(Icons.picture_as_pdf_outlined, color: AppColors.expense),
                  title: const Text(AppStrings.backupExport),
                  subtitle: const Text('Exporta todas as movimentações em PDF'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _exportBackupPdf(context, transactionProvider),
                ),
              ),
              const SizedBox(height: 24),

              // ─── Sobre ──────────────────────────────
              _buildSectionHeader(theme, 'Sobre', Icons.info_outline),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.account_balance_wallet, size: 40, color: AppColors.primary),
                      const SizedBox(height: 12),
                      Text(
                        AppStrings.appName,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Versão ${AppStrings.appVersion}',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Controle financeiro simples e inteligente.',
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: theme.textTheme.titleMedium),
      ],
    );
  }

  // ─── Editar Limite Mensal ────────────────────────────────
  void _editMonthlyLimit(BuildContext context, SettingsProvider provider) {
    final controller = TextEditingController(
      text: provider.monthlyLimit.toStringAsFixed(2),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.monthlyLimit),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            prefixText: 'R\$ ',
            hintText: '0.00',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(
                controller.text.replaceAll(',', '.'),
              );
              if (value != null && value > 0) {
                provider.updateMonthlyLimit(value);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Limite atualizado com sucesso!')),
                );
              }
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
  }

  // ─── Editar Moeda ───────────────────────────────────────
  void _editCurrency(BuildContext context, SettingsProvider provider) {
    final currencies = ['BRL', 'USD', 'EUR'];

    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Selecionar Moeda'),
        children: currencies.map((c) {
          return SimpleDialogOption(
            onPressed: () {
              provider.updateCurrency(c);
              Navigator.pop(ctx);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    c == provider.currency ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(c, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Backup PDF ─────────────────────────────────────────
  Future<void> _exportBackupPdf(BuildContext context, TransactionProvider provider) async {
    final scaffold = ScaffoldMessenger.of(context);

    scaffold.showSnackBar(
      const SnackBar(content: Text('Gerando backup em PDF...')),
    );

    try {
      final transactions = provider.transactions;
      final pdf = pw.Document();
      final dateFormat = DateFormat('dd/MM/yyyy');

      final totalIncome = transactions.where((t) => t.isIncome).fold(0.0, (s, t) => s + t.amount);
      final totalExpense = transactions.where((t) => t.isExpense).fold(0.0, (s, t) => s + t.amount);
      final balance = totalIncome - totalExpense;

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (ctx) => [
            pw.Header(level: 0, text: 'Backup - Controle Pessoal'),
            pw.Text('Gerado em: ${dateFormat.format(DateTime.now())}'),
            pw.Text('Total de movimentações: ${transactions.length}'),
            pw.SizedBox(height: 12),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Text('Receitas: R\$ ${totalIncome.toStringAsFixed(2)}'),
              pw.Text('Despesas: R\$ ${totalExpense.toStringAsFixed(2)}'),
              pw.Text('Saldo: R\$ ${balance.toStringAsFixed(2)}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ]),
            pw.SizedBox(height: 16),
            if (transactions.isNotEmpty)
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
                cellStyle: const pw.TextStyle(fontSize: 8),
                headers: ['Data', 'Tipo', 'Descrição', 'Valor', 'Pagamento'],
                data: transactions.map((t) => [
                  dateFormat.format(t.date),
                  t.isIncome ? 'Receita' : 'Despesa',
                  t.description,
                  'R\$ ${t.amount.toStringAsFixed(2)}',
                  t.paymentMethod,
                ]).toList(),
              ),
          ],
        ),
      );

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/backup_controle_pessoal.pdf');
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([XFile(file.path)], text: 'Backup - Controle Pessoal');

      scaffold.showSnackBar(
        const SnackBar(content: Text('Backup gerado com sucesso!')),
      );
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(content: Text('Erro ao gerar backup: $e')),
      );
    }
  }
}
