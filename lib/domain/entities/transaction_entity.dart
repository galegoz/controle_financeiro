class TransactionEntity {
  final String id;
  final String type; // 'income' ou 'expense'
  final DateTime date;
  final String description;
  final double amount;
  final String paymentMethod;

  TransactionEntity({
    required this.id,
    required this.type,
    required this.date,
    required this.description,
    required this.amount,
    required this.paymentMethod,
  });

  bool get isIncome => type == 'income';
  bool get isExpense => type == 'expense';
}
