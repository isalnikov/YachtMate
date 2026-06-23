import 'package:drift/drift.dart';

/// Cached JSON tide response keyed by coarse lat/lon grid (Step 42).
@DataClassName('TidesCacheRow')
class TidesCacheRows extends Table {
  TextColumn get gridKey => text()();

  TextColumn get tidesJson => text()();

  IntColumn get fetchedAtMs => integer()();

  IntColumn get expiresAtMs => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {gridKey};
}
