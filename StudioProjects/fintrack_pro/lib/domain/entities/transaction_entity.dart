class TransactionEntity {
  final int? id;
  final double amount;
  final String category;
  final String type;
  final DateTime date;
  final String? note;
  final String? receiptPath;
  final bool recurring;
  final String? recurringType;

  const TransactionEntity({
    this.id,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
    this.note,
    this.receiptPath,
    required this.recurring,
    this.recurringType,
  });

  TransactionEntity copyWith({
    int? id,
    double? amount,
    String? category,
    String? type,
    DateTime? date,
    String? note,
    String? receiptPath,
    bool? recurring,
    String? recurringType,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      type: type ?? this.type,
      date: date ?? this.date,
      note: note ?? this.note,
      receiptPath: receiptPath ?? this.receiptPath,
      recurring: recurring ?? this.recurring,
      recurringType: recurringType ?? this.recurringType,
    );
  }
}