import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository_contract.dart';

class UpdateTransaction {
  final TransactionRepositoryContract repository;

  UpdateTransaction(this.repository);

  Future<void> call(TransactionEntity transaction) {
    return repository.updateTransaction(transaction);
  }
}