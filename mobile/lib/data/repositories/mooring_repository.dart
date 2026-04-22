import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../local/app_database.dart';

/// Каталог марин / якорных стоянок и офлайн-очередь отзывов (Фаза 6).
class MooringRepository {
  MooringRepository(this._db);

  final AppDatabase _db;

  static const _uuid = Uuid();

  static const seedAssetPath = 'assets/mooring/demo_moorings_fethiye.geojson';

  /// Идempotent: один раз загружает демо-каталог, если таблица пуста.
  Future<void> ensureSeedLoaded() async {
    final existing = await _db.select(_db.mooringPlaces).get();
    if (existing.isNotEmpty) return;

    final raw = await rootBundle.loadString(seedAssetPath);
    final root = jsonDecode(raw) as Map<String, dynamic>;
    await replaceFromGeoJson(root);
  }

  Future<void> replaceFromGeoJson(Map<String, dynamic> root) async {
    final feats = root['features'];
    if (feats is! List<dynamic>) return;

    await _db.transaction(() async {
      await _db.delete(_db.mooringPlaces).go();
      for (final raw in feats) {
        if (raw is! Map<String, dynamic>) continue;
        final geom = raw['geometry'];
        final props = raw['properties'];
        if (geom is! Map<String, dynamic>) continue;
        if (geom['type'] != 'Point') continue;
        if (props is! Map<String, dynamic>) continue;

        final coords = geom['coordinates'];
        if (coords is! List || coords.length < 2) continue;
        final lon = (coords[0] as num).toDouble();
        final lat = (coords[1] as num).toDouble();

        final id = props['id'] as String?;
        final kind = props['kind'] as String?;
        final name = props['name'] as String?;
        if (id == null || kind == null || name == null) continue;

        final rawSvc = props['services'];
        final servicesJson = rawSvc is Map ? jsonEncode(rawSvc) : null;

        await _db.into(_db.mooringPlaces).insert(
              MooringPlacesCompanion.insert(
                id: id,
                kind: kind,
                name: name,
                lat: lat,
                lon: lon,
                vhf: Value(props['vhf'] as String?),
                phone: Value(props['phone'] as String?),
                servicesJson: Value(servicesJson),
                notes: Value(props['notes'] as String?),
              ),
            );
      }
    });
  }

  Future<MooringPlaceRow?> placeById(String id) {
    return (_db.select(_db.mooringPlaces)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<MooringPlaceRow>> allPlaces() {
    return (_db.select(_db.mooringPlaces)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<void> queueReviewDraft({
    required String placeId,
    required int stars,
    String? comment,
  }) async {
    final sid = _uuid.v4();
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.into(_db.mooringReviewDrafts).insert(
          MooringReviewDraftsCompanion.insert(
            id: sid,
            placeId: placeId,
            stars: stars.clamp(1, 5),
            comment: Value(comment),
            createdAtMs: now,
            synced: const Value(false),
          ),
        );
  }

  Future<List<MooringReviewDraftRow>> pendingReviews() {
    return (_db.select(_db.mooringReviewDrafts)
          ..where((t) => t.synced.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAtMs)]))
        .get();
  }
}
