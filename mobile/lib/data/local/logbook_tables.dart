import 'package:drift/drift.dart';

/// Судовой журнал (Фаза 7.1). payload_json — произвольный JSON категории (без PII в аудите).
@DataClassName('LogbookEntryRow')
class LogbookEntries extends Table {
  TextColumn get id => text()();

  IntColumn get t => integer()();

  TextColumn get category => text()();

  TextColumn get payloadJson => text()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
