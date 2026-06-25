import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/local/database_helper.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final DatabaseHelper _databaseHelper;

  TransactionRepositoryImpl(this._databaseHelper);

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'transactions',
      orderBy: 'date DESC',
    );

    return maps.map((map) => TransactionModel.fromMap(map)).toList();
  }

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    final db = await _databaseHelper.database;
    final model = TransactionModel.fromEntity(transaction);
    await db.insert('transactions', model.toMap());
  }

  @override
  Future<void> updateTransaction(TransactionEntity transaction) async {
    final db = await _databaseHelper.database;
    final model = TransactionModel.fromEntity(transaction);
    await db.update(
      'transactions',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
