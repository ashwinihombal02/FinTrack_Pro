import '../repositories/transaction_repository_contract.dart';

class DeleteTransaction {
  final TransactionRepositoryContract repository;

  DeleteTransaction(this.repository);

  Future<void> call(int id) {
    return repository.deleteTransaction(id);
  }
}