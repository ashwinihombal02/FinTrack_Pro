import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository_contract.dart';

class GetTransactions {
  final TransactionRepositoryContract repository;

  GetTransactions(this.repository);

  Stream<List<TransactionEntity>> call() {
    return repository.watchTransactions();
  }
}