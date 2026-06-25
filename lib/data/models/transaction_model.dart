import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.id,
    required super.type,
    required super.date,
    required super.description,
    required super.amount,
    required super.paymentMethod,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      type: map['type'] as String,
      date: DateTime.parse(map['date'] as String),
      description: map['description'] as String,
      amount: map['amount'] as double,
      paymentMethod: map['paymentMethod'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'date': date.toIso8601String(),
      'description': description,
      'amount': amount,
      'paymentMethod': paymentMethod,
    };
  }

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      type: entity.type,
      date: entity.date,
      description: entity.description,
      amount: entity.amount,
      paymentMethod: entity.paymentMethod,
    );
  }
}
