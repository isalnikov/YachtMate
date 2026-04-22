import 'package:drift/drift.dart';

import '../local/app_database.dart';

/// Tracks downloaded chart / offline regions on disk (Фаза 1.3).
class ChartRegionRepository {
  ChartRegionRepository(this._db);

  final AppDatabase _db;

  Future<void> upsert({
    required String regionId,
    required String path,
    required String licenseTier,
    String? checksum,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.into(_db.chartRegions).insertOnConflictUpdate(
          ChartRegionsCompanion.insert(
            regionId: regionId,
            path: path,
            installedAt: now,
            licenseTier: licenseTier,
            checksum: Value(checksum),
          ),
        );
  }

  Future<List<ChartRegionRow>> all() => _db.select(_db.chartRegions).get();

  Future<void> delete(String regionId) async {
    await (_db.delete(_db.chartRegions)..where((c) => c.regionId.equals(regionId)))
        .go();
  }
}
