import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository_contract.dart';

  class WatchTransactions {
  final TransactionRepositoryContract repository;

  WatchTransactions(this.repository);

  Stream<List<TransactionEntity>> call() {
    return repository.watchTransactions();
  }
}