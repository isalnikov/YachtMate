import 'package:drift/drift.dart';

/// Cached GRIB import decode result (step 67).
@DataClassName('GribImportCacheRow')
class GribImportCache extends Table {
  TextColumn get path => text()();

  IntColumn get importedAtMs => integer()();

  TextColumn get decodeSummary => text().nullable()();

  TextColumn get decodeError => text().nullable()();

  TextColumn get windSampleLabel => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {path};
}
