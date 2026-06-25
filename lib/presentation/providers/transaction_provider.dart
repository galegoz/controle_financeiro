import 'package:flutter/material.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _repository;

  List<TransactionEntity> _transactions = [];
  bool _isLoading = false;

  TransactionProvider(this._repository) {
    loadTransactions();
  }

  List<TransactionEntity> get transactions => _transactions;
  bool get isLoading => _isLoading;

  Future<void> loadTransactions() async {
    _isLoading = true;
    notifyListeners();

    _transactions = await _repository.getTransactions();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTransaction(TransactionEntity transaction) async {
    await _repository.addTransaction(transaction);
    await loadTransactions();
  }

  Future<void> updateTransaction(TransactionEntity transaction) async {
    await _repository.updateTransaction(transaction);
    await loadTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    await _repository.deleteTransaction(id);
    await loadTransactions();
  }
}
