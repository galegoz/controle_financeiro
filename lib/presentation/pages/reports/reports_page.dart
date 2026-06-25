import 'dart:io';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
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
import '../../../domain/entities/transaction_entity.dart';
import '../../providers/transaction_provider.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.reports),
      ),
      body: const ReportsContent(),
    );
  }
}

class ReportsContent extends StatefulWidget {
  const ReportsContent({super.key});

  @override
  State<ReportsContent> createState() => _ReportsContentState();
}

class _ReportsContentState extends State<ReportsContent> {
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate = DateTime.now();
  bool _isExporting = false;

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  List<TransactionEntity> _filteredTransactions(List<TransactionEntity> all) {
    return all.where((t) {
      return !t.date.isBefore(_startDate) &&
          !t.date.isAfter(_endDate.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          final filtered = _filteredTransactions(provider.transactions);
          final totalIncome = filtered.where((t) => t.isIncome).fold(0.0, (s, t) => s + t.amount);
          final totalExpense = filtered.where((t) => t.isExpense).fold(0.0, (s, t) => s + t.amount);
          final balance = totalIncome - totalExpense;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Filtros de data
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.period, style: theme.textTheme.titleMedium),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => _pickDate(true),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: AppStrings.startDate,
                                    prefixIcon: Icon(Icons.calendar_today_outlined),
                                    isDense: true,
                                  ),
                                  child: Text(AppFormatters.formatDate(_startDate)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: InkWell(
                                onTap: () => _pickDate(false),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: AppStrings.endDate,
                                    prefixIcon: Icon(Icons.calendar_today_outlined),
                                    isDense: true,
                                  ),
                                  child: Text(AppFormatters.formatDate(_endDate)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Resumo do período
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildSummaryRow(theme, 'Receitas', AppFormatters.formatCurrency(totalIncome), AppColors.income),
                        const Divider(height: 20),
                        _buildSummaryRow(theme, 'Despesas', AppFormatters.formatCurrency(totalExpense), AppColors.expense),
                        const Divider(height: 20),
                        _buildSummaryRow(theme, 'Saldo', AppFormatters.formatCurrency(balance), balance >= 0 ? AppColors.income : AppColors.expense),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Contagem
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '${filtered.length} movimentação(ões) no período selecionado',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Botões de exportação
                if (_isExporting)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  _buildExportButton(
                    icon: Icons.picture_as_pdf_outlined,
                    label: AppStrings.exportPdf,
                    color: AppColors.expense,
                    onTap: () => _exportPdf(filtered, totalIncome, totalExpense, balance),
                  ),
                  const SizedBox(height: 10),
                  _buildExportButton(
                    icon: Icons.table_chart_outlined,
                    label: AppStrings.exportExcel,
                    color: AppColors.income,
                    onTap: () => _exportExcel(filtered),
                  ),
                  const SizedBox(height: 10),
                  _buildExportButton(
                    icon: Icons.description_outlined,
                    label: AppStrings.exportCsv,
                    color: AppColors.primary,
                    onTap: () => _exportCsv(filtered),
                  ),
                ],
              ],
            ),
          );
        },
      );
  }

  Widget _buildSummaryRow(ThemeData theme, String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        Text(value, style: theme.textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildExportButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Icon(icon, color: color),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withAlpha(128)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onTap,
      ),
    );
  }

  // ─── PDF ──────────────────────────────────────────────────
  Future<void> _exportPdf(List<TransactionEntity> data, double income, double expense, double balance) async {
    setState(() => _isExporting = true);
    try {
      final pdf = pw.Document();
      final dateFormat = DateFormat('dd/MM/yyyy');

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (ctx) => [
            pw.Header(level: 0, text: 'Relatório Financeiro'),
            pw.Text('Período: ${dateFormat.format(_startDate)} - ${dateFormat.format(_endDate)}'),
            pw.SizedBox(height: 16),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Text('Total de Receitas: R\$ ${income.toStringAsFixed(2)}'),
              pw.Text('Total de Despesas: R\$ ${expense.toStringAsFixed(2)}'),
            ]),
            pw.Text('Saldo do Período: R\$ ${balance.toStringAsFixed(2)}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
              cellStyle: const pw.TextStyle(fontSize: 9),
              headers: ['Data', 'Tipo', 'Descrição', 'Valor', 'Pagamento'],
              data: data.map((t) => [
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

      await _shareFile(await pdf.save(), 'relatorio.pdf');
    } finally {
      setState(() => _isExporting = false);
    }
  }

  // ─── Excel ────────────────────────────────────────────────
  Future<void> _exportExcel(List<TransactionEntity> data) async {
    setState(() => _isExporting = true);
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Movimentações'];

      sheet.appendRow([
        TextCellValue('Data'),
        TextCellValue('Tipo'),
        TextCellValue('Descrição'),
        TextCellValue('Valor'),
        TextCellValue('Forma de Pagamento'),
      ]);

      for (final t in data) {
        sheet.appendRow([
          TextCellValue(AppFormatters.formatDate(t.date)),
          TextCellValue(t.isIncome ? 'Receita' : 'Despesa'),
          TextCellValue(t.description),
          DoubleCellValue(t.amount),
          TextCellValue(t.paymentMethod),
        ]);
      }

      final bytes = excel.encode();
      if (bytes != null) {
        await _shareFile(bytes, 'relatorio.xlsx');
      }
    } finally {
      setState(() => _isExporting = false);
    }
  }

  // ─── CSV ──────────────────────────────────────────────────
  Future<void> _exportCsv(List<TransactionEntity> data) async {
    setState(() => _isExporting = true);
    try {
      final rows = <List<String>>[
        ['Data', 'Tipo', 'Descrição', 'Valor', 'Forma de Pagamento'],
        ...data.map((t) => [
          AppFormatters.formatDate(t.date),
          t.isIncome ? 'Receita' : 'Despesa',
          t.description,
          t.amount.toStringAsFixed(2),
          t.paymentMethod,
        ]),
      ];

      final csv = const ListToCsvConverter().convert(rows);
      await _shareFile(csv.codeUnits, 'relatorio.csv');
    } finally {
      setState(() => _isExporting = false);
    }
  }

  // ─── Compartilhar ─────────────────────────────────────────
  Future<void> _shareFile(List<int> bytes, String filename) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles([XFile(file.path)], text: 'Relatório Financeiro');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$filename gerado com sucesso!')),
      );
    }
  }
}
