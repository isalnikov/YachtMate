import 'package:drift/drift.dart';

/// Метаданные записей УКВ-тренажёра (F12).
@DataClassName('VhfRecordingRow')
class VhfRecordings extends Table {
  TextColumn get id => text()();

  IntColumn get t => integer()();

  TextColumn get path => text()();

  TextColumn get transcript => text().nullable()();

  IntColumn get durationMs => integer().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
