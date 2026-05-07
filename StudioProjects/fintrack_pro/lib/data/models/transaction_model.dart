class TransactionModel {
  final int? id;

  final double amount;

  final String category;

  final String type;

  final DateTime date;

  final String? note;

  final String? receiptPath;

  final bool recurring;

  final String? recurringType;

  TransactionModel({
    this.id,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
    this.note,
    this.receiptPath,
    this.recurring = false,
    this.recurringType,
  });
}