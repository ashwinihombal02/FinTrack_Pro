import '../entities/transaction_entity.dart';

abstract class TransactionRepositoryContract {
  Future<void> addTransaction(TransactionEntity transaction);

  Future<void> deleteTransaction(int id);

  Future<void> updateTransaction(TransactionEntity transaction);

  Stream<List<TransactionEntity>> watchTransactions();
}