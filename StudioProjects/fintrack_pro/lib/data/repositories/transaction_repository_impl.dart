import 'package:drift/drift.dart';

import '../../data/db/app_database.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository_contract.dart';

class TransactionRepositoryImpl implements TransactionRepositoryContract {
  final AppDatabase db;

  TransactionRepositoryImpl(this.db);

  @override
  Future<void> addTransaction(TransactionEntity entity) async {
    await db.insertTransaction(
      TransactionsCompanion.insert(
        amount: entity.amount,
        category: entity.category,
        type: entity.type,
        date: entity.date,
        note: Value(entity.note),
        receiptPath: Value(entity.receiptPath),
        recurring: Value(entity.recurring),
        recurringType: Value(entity.recurringType),
      ),
    );
  }

  @override
  Stream<List<TransactionEntity>> watchTransactions() {
    return db.watchAllTransactions().map(
          (rows) => rows.map((e) {
        return TransactionEntity(
          id: e.id,
          amount: e.amount,
          category: e.category,
          type: e.type,
          date: e.date,
          note: e.note,
          receiptPath: e.receiptPath,
          recurring: e.recurring,
          recurringType: e.recurringType,
        );
      }).toList(),
    );
  }

  @override
  Future<void> deleteTransaction(int id) {
    return db.deleteTransaction(id);
  }

  @override
  Future<void> updateTransaction(TransactionEntity tx) {
    return (db.update(db.transactions)..where((t) => t.id.equals(tx.id!)))
        .write(
      TransactionsCompanion(
        amount: Value(tx.amount),
        category: Value(tx.category),
        type: Value(tx.type),
        date: Value(tx.date),
        note: Value(tx.note),
        receiptPath: Value(tx.receiptPath),
        recurring: Value(tx.recurring),
        recurringType: Value(tx.recurringType),
      ),
    );
  }
}