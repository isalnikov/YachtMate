import 'package:drift/drift.dart';

/// Расходы рейса / судовая касса (F14).
@DataClassName('ExpenseEntryRow')
class ExpenseEntries extends Table {
  TextColumn get id => text()();

  IntColumn get t => integer()();

  /// fuel, food, marina, mooring_fee, gear, provisions, other
  TextColumn get category => text()();

  /// В минимальных единицах валюты (центы).
  IntColumn get amountMinor => integer()();

  TextColumn get currency => text().withDefault(const Constant('EUR'))();

  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
