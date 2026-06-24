import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/grib/grib_import_storage.dart';
import '../local/app_database.dart';

/// GRIB import list + decode cache in Drift (step 67).
class GribImportRepository {
  GribImportRepository(this._db);

  final AppDatabase _db;

  Future<List<GribImportFile>> listAll() async {
    final rows = await (_db.select(_db.gribImportCache)
          ..orderBy([(t) => OrderingTerm.desc(t.importedAtMs)]))
        .get();
    return rows.map(_rowToFile).toList(growable: false);
  }

  Future<GribImportFile?> getByPath(String path) async {
    final row = await (_db.select(_db.gribImportCache)
          ..where((t) => t.path.equals(path)))
        .getSingleOrNull();
    return row == null ? null : _rowToFile(row);
  }

  Future<GribImportFile> importAndDecode(String path) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final decoded = await decodeGribImportFile(
      GribImportFile(path: path, importedAtMs: now),
    );
    await _upsert(decoded);
    return decoded;
  }

  Future<void> _upsert(GribImportFile file) async {
    await _db.into(_db.gribImportCache).insertOnConflictUpdate(
          GribImportCacheCompanion.insert(
            path: file.path,
            importedAtMs: file.importedAtMs ?? DateTime.now().millisecondsSinceEpoch,
            decodeSummary: Value(file.decodeSummary),
            decodeError: Value(file.decodeError),
            windSampleLabel: Value(file.windSampleLabel),
          ),
        );
  }

  /// One-time migration from SharedPreferences stub keys (step 44).
  Future<void> migrateLegacyPrefs(SharedPreferences prefs) async {
    final legacy = loadGribImports(prefs);
    if (legacy.isEmpty) return;

    for (final stub in legacy) {
      final existing = await getByPath(stub.path);
      if (existing != null) continue;
      await importAndDecode(stub.path);
    }

    await prefs.remove(gribImportListPrefsKey);
    await prefs.remove(gribLegacyPathPrefsKey);
  }

  GribImportFile _rowToFile(GribImportCacheRow row) {
    return GribImportFile(
      path: row.path,
      importedAtMs: row.importedAtMs,
      decodeSummary: row.decodeSummary,
      decodeError: row.decodeError,
      windSampleLabel: row.windSampleLabel,
    );
  }
}
