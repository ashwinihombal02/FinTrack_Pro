import 'package:drift/drift.dart';

/// ===============================
/// TRANSACTIONS TABLE
/// ===============================
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get amount => real()();

  TextColumn get category => text()();

  TextColumn get type => text()(); // income / expense

  DateTimeColumn get date => dateTime()();

  TextColumn get note => text().nullable()();

  TextColumn get receiptPath => text().nullable()();

  BoolColumn get recurring =>
      boolean().withDefault(const Constant(false))();

  TextColumn get recurringType =>
      text().nullable()(); // daily / weekly / monthly
}

/// ===============================
/// CATEGORIES TABLE
/// ===============================
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get type => text()(); // income / expense

  IntColumn get color => integer()(); // store ARGB

  BoolColumn get isDefault =>
      boolean().withDefault(const Constant(false))();
}

/// ===============================
/// BUDGETS TABLE
/// ===============================
class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get category => text()();

  RealColumn get limitAmount => real()();

  DateTimeColumn get startDate => dateTime()();

  DateTimeColumn get endDate => dateTime()();

  RealColumn get spent =>
      real().withDefault(const Constant(0))();
}