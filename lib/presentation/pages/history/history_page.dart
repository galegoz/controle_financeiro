import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/transaction/transaction_list_item.dart';
import '../transaction/transaction_form_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _searchQuery = '';
  String _filterType = 'all'; // all, income, expense

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.history),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          var transactions = provider.transactions;

          // Filtro por tipo
          if (_filterType != 'all') {
            transactions = transactions.where((t) => t.type == _filterType).toList();
          }

          // Filtro por busca
          if (_searchQuery.isNotEmpty) {
            transactions = transactions
                .where((t) => t.description.toLowerCase().contains(_searchQuery.toLowerCase()))
                .toList();
          }

          return Column(
            children: [
              // Barra de pesquisa e filtros
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: AppStrings.searchHint,
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) => setState(() => _searchQuery = value),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('all', AppStrings.all),
                          const SizedBox(width: 8),
                          _buildFilterChip('income', AppStrings.income),
                          const SizedBox(width: 8),
                          _buildFilterChip('expense', AppStrings.expense),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Lista de transações
              Expanded(
                child: transactions.isEmpty
                    ? Center(
                        child: Text(
                          AppStrings.noTransactions,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          return TransactionListItem(
                            transaction: transaction,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TransactionFormPage(transaction: transaction),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filterType == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _filterType = value);
        }
      },
    );
  }
}
