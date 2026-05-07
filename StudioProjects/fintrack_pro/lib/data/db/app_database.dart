import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/transaction_entity.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Transactions, Categories, Budgets],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // =========================
  // CREATE
  // =========================
  Future<int> insertTransaction(TransactionsCompanion data) {
    return into(transactions).insert(data);
  }

  // =========================
  // READ (REAL OFFLINE STREAM)
  // =========================
  Stream<List<Transaction>> watchAllTransactions() {
    return (select(transactions)
      ..orderBy([
            (t) => OrderingTerm(
          expression: t.date,
          mode: OrderingMode.desc,
        )
      ]))
        .watch();
  }

  Future<int> deleteTransaction(int id) {
    return (delete(transactions)
      ..where((t) => t.id.equals(id)))
        .go();
  }

  // =========================
  // UPDATE (CLEAN VERSION)
  // =========================
  Future<int> updateTransaction(TransactionEntity entity) {
    return (update(transactions)
      ..where((t) => t.id.equals(entity.id!)))
        .write(
      TransactionsCompanion(
        id: Value(entity.id!),
        amount: Value(entity.amount),
        category: Value(entity.category),
        type: Value(entity.type),
        date: Value(entity.date),
        note: Value(entity.note),
        receiptPath: Value(entity.receiptPath),
        recurring: Value(entity.recurring),
        recurringType: Value(entity.recurringType),
      ),
    );
  }
  // =========================
  // CLEAR ALL (DEV ONLY)
  // =========================
  Future<void> clearAllTransactions() {
    return delete(transactions).go();
  }
}

// =========================
// DATABASE FILE CONNECTION
// =========================
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'fintrack_pro.sqlite'));
    return NativeDatabase(file);
  });
}