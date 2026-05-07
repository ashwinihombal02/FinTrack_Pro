import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository_contract.dart';

class AddTransaction {
  final TransactionRepositoryContract repository;

  AddTransaction(this.repository);

  Future<void> call(
      TransactionEntity transaction,
      ) async {
    await repository.addTransaction(transaction);
  }
}