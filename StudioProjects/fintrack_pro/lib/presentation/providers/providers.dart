import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository_contract.dart';
import '../../domain/usecases/get_transactions.dart';
import '../../domain/usecases/delete_transaction.dart';

/// ==========================
/// DATABASE
/// ==========================
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// ==========================
/// REPOSITORY
/// ==========================
final transactionRepositoryProvider =
Provider<TransactionRepositoryContract>((ref) {
  return TransactionRepositoryImpl(
    ref.read(databaseProvider),
  );
});

/// ==========================
/// USECASE
/// ==========================
final getTransactionsProvider = Provider<GetTransactions>((ref) {
  return GetTransactions(
    ref.read(transactionRepositoryProvider),
  );
});
final deleteTransactionProvider = Provider<DeleteTransaction>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return DeleteTransaction(repo);
});
/// ==========================
/// STREAM (IMPORTANT FIX)
/// ==========================
final transactionProvider =
StreamProvider<List<TransactionEntity>>((ref) {
  final usecase = ref.read(getTransactionsProvider);
  return usecase();
});