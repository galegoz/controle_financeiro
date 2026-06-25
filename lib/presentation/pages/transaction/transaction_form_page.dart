import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../providers/transaction_provider.dart';

class TransactionFormPage extends StatefulWidget {
  final TransactionEntity? transaction;

  const TransactionFormPage({super.key, this.transaction});

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late String _type;
  late DateTime _date;
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late String _paymentMethod;

  @override
  void initState() {
    super.initState();
    final isEdit = widget.transaction != null;
    
    _type = isEdit ? widget.transaction!.type : 'expense';
    _date = isEdit ? widget.transaction!.date : DateTime.now();
    _descriptionController = TextEditingController(text: isEdit ? widget.transaction!.description : '');
    _amountController = TextEditingController(text: isEdit ? widget.transaction!.amount.toStringAsFixed(2) : '');
    _paymentMethod = isEdit ? widget.transaction!.paymentMethod : AppStrings.paymentCash;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
      if (amount == null) return;

      final transaction = TransactionEntity(
        id: widget.transaction?.id ?? _uuid.v4(),
        type: _type,
        date: _date,
        description: _descriptionController.text,
        amount: amount,
        paymentMethod: _paymentMethod,
      );

      final provider = context.read<TransactionProvider>();
      if (widget.transaction == null) {
        provider.addTransaction(transaction);
      } else {
        provider.updateTransaction(transaction);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.transaction != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? AppStrings.editTransaction : AppStrings.newTransaction),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tipo
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'expense',
                    label: Text(AppStrings.expense),
                    icon: Icon(Icons.arrow_downward),
                  ),
                  ButtonSegment(
                    value: 'income',
                    label: Text(AppStrings.income),
                    icon: Icon(Icons.arrow_upward),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _type = newSelection.first;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return _type == 'expense'
                          ? AppColors.expense.withAlpha(50)
                          : AppColors.income.withAlpha(50);
                    }
                    return null;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return _type == 'expense' ? AppColors.expense : AppColors.income;
                    }
                    return null;
                  }),
                ),
              ),
              const SizedBox(height: 24),

              // Valor
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: AppStrings.fieldAmount,
                  prefixText: 'R\$ ',
                  prefixStyle: theme.textTheme.titleMedium?.copyWith(
                    color: _type == 'expense' ? AppColors.expense : AppColors.income,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: theme.textTheme.titleLarge,
                validator: (value) {
                  if (value == null || value.isEmpty) return AppStrings.required;
                  if (double.tryParse(value.replaceAll(',', '.')) == null) {
                    return AppStrings.invalidAmount;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Descrição
              TextFormField(
                controller: _descriptionController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: AppStrings.fieldDescription,
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return AppStrings.required;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Data
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: AppStrings.fieldDate,
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    "${_date.day.toString().padLeft(2, '0')}/${_date.month.toString().padLeft(2, '0')}/${_date.year}",
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Forma de pagamento
              DropdownButtonFormField<String>(
                initialValue: _paymentMethod,
                decoration: const InputDecoration(
                  labelText: AppStrings.fieldPaymentMethod,
                  prefixIcon: Icon(Icons.payment_outlined),
                ),
                items: AppStrings.paymentMethods.map((String method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _paymentMethod = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 32),

              // Botão Salvar
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text(AppStrings.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
