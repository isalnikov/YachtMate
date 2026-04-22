import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../local/app_database.dart';
import 'mooring_review_outbound_client.dart';

/// Импорт каталога GeoJSON и офлайн-очередь отзывов (Фаза 6).
///
/// **Merge-каталог:** при [mergeFromGeoJson] более новая строка по [MooringPlaceRow.sourceUpdatedAtMs]
/// заменяет старую; если в пакете нет метки времени, используется текущее время — импорт «побеждает»
/// записи без версии (до появления колонки в миграции v5).
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
        final parsed = _parseFeature(raw);
        if (parsed == null) continue;

        await _db
            .into(_db.mooringPlaces)
            .insert(
              MooringPlacesCompanion.insert(
                id: parsed.id,
                kind: parsed.kind,
                name: parsed.name,
                lat: parsed.lat,
                lon: parsed.lon,
                vhf: Value(parsed.vhf),
                phone: Value(parsed.phone),
                email: Value(parsed.email),
                websiteUrl: Value(parsed.websiteUrl),
                bookingUrl: Value(parsed.bookingUrl),
                servicesJson: Value(parsed.servicesJson),
                notes: Value(parsed.notes),
                sourceUpdatedAtMs: Value(parsed.sourceUpdatedAtMs),
              ),
            );
      }
    });
  }

  /// Инкрементальный импорт пакета: upsert по `id`, конфликт по `sourceUpdatedAtMs`.
  Future<MooringCatalogMergeStats> mergeFromGeoJson(
    Map<String, dynamic> root,
  ) async {
    final feats = root['features'];
    if (feats is! List<dynamic>) {
      return const MooringCatalogMergeStats(
        inserted: 0,
        updated: 0,
        skippedOlderOrEqual: 0,
      );
    }

    var inserted = 0;
    var updated = 0;
    var skippedOlderOrEqual = 0;

    await _db.transaction(() async {
      for (final raw in feats) {
        if (raw is! Map<String, dynamic>) continue;
        final parsed = _parseFeature(raw);
        if (parsed == null) continue;

        final incomingTs =
            parsed.sourceUpdatedAtMs ?? DateTime.now().millisecondsSinceEpoch;
        final existing = await placeById(parsed.id);
        if (existing != null &&
            (existing.sourceUpdatedAtMs ?? 0) >= incomingTs) {
          skippedOlderOrEqual++;
          continue;
        }

        await _db
            .into(_db.mooringPlaces)
            .insertOnConflictUpdate(
              MooringPlacesCompanion.insert(
                id: parsed.id,
                kind: parsed.kind,
                name: parsed.name,
                lat: parsed.lat,
                lon: parsed.lon,
                vhf: Value(parsed.vhf),
                phone: Value(parsed.phone),
                email: Value(parsed.email),
                websiteUrl: Value(parsed.websiteUrl),
                bookingUrl: Value(parsed.bookingUrl),
                servicesJson: Value(parsed.servicesJson),
                notes: Value(parsed.notes),
                sourceUpdatedAtMs: Value(parsed.sourceUpdatedAtMs),
              ),
            );

        if (existing == null) {
          inserted++;
        } else {
          updated++;
        }
      }
    });

    return MooringCatalogMergeStats(
      inserted: inserted,
      updated: updated,
      skippedOlderOrEqual: skippedOlderOrEqual,
    );
  }

  Future<MooringPlaceRow?> placeById(String id) {
    return (_db.select(
      _db.mooringPlaces,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<MooringPlaceRow>> allPlaces() {
    return (_db.select(
      _db.mooringPlaces,
    )..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
  }

  Future<void> queueReviewDraft({
    required String placeId,
    required int stars,
    String? comment,
  }) async {
    final sid = _uuid.v4();
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db
        .into(_db.mooringReviewDrafts)
        .insert(
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

  Future<void> markReviewDraftSynced(String draftId) async {
    await (_db.update(_db.mooringReviewDrafts)
          ..where((t) => t.id.equals(draftId)))
        .write(const MooringReviewDraftsCompanion(synced: Value(true)));
  }

  /// Отправляет очередь через [client]. При успехе черновик помечается `synced`.
  Future<MooringReviewSyncStats> syncPendingReviews(
    MooringReviewOutboundClient client,
  ) async {
    final drafts = await pendingReviews();
    var submitted = 0;
    var failed = 0;
    for (final d in drafts) {
      final r = await client.submit(d);
      if (r.accepted) {
        await markReviewDraftSynced(d.id);
        submitted++;
      } else {
        failed++;
      }
    }
    return MooringReviewSyncStats(submitted: submitted, failed: failed);
  }
}

/// Сводка импорта каталога.
class MooringCatalogMergeStats {
  const MooringCatalogMergeStats({
    required this.inserted,
    required this.updated,
    required this.skippedOlderOrEqual,
  });

  final int inserted;
  final int updated;
  final int skippedOlderOrEqual;
}

/// Сводка синхронизации черновиков отзывов.
class MooringReviewSyncStats {
  const MooringReviewSyncStats({required this.submitted, required this.failed});

  final int submitted;
  final int failed;
}

class _ParsedMooringFeature {
  _ParsedMooringFeature({
    required this.id,
    required this.kind,
    required this.name,
    required this.lat,
    required this.lon,
    this.vhf,
    this.phone,
    this.email,
    this.websiteUrl,
    this.bookingUrl,
    this.servicesJson,
    this.notes,
    this.sourceUpdatedAtMs,
  });

  final String id;
  final String kind;
  final String name;
  final double lat;
  final double lon;
  final String? vhf;
  final String? phone;
  final String? email;
  final String? websiteUrl;
  final String? bookingUrl;
  final String? servicesJson;
  final String? notes;
  final int? sourceUpdatedAtMs;
}

_ParsedMooringFeature? _parseFeature(Map<String, dynamic> raw) {
  final geom = raw['geometry'];
  final props = raw['properties'];
  if (geom is! Map<String, dynamic>) return null;
  if (geom['type'] != 'Point') return null;
  if (props is! Map<String, dynamic>) return null;

  final coords = geom['coordinates'];
  if (coords is! List || coords.length < 2) return null;
  final lon = (coords[0] as num).toDouble();
  final lat = (coords[1] as num).toDouble();

  final id = props['id'] as String?;
  final kind = props['kind'] as String?;
  final name = props['name'] as String?;
  if (id == null || kind == null || name == null) return null;

  final rawSvc = props['services'];
  final servicesJson = rawSvc is Map ? jsonEncode(rawSvc) : null;

  final web = props['websiteUrl'] as String? ?? props['website'] as String?;
  final booking =
      props['bookingUrl'] as String? ?? props['bookingLink'] as String?;

  final tsRaw = props['sourceUpdatedAtMs'];
  final sourceUpdatedAtMs = tsRaw is num ? tsRaw.toInt() : null;

  return _ParsedMooringFeature(
    id: id,
    kind: kind,
    name: name,
    lat: lat,
    lon: lon,
    vhf: props['vhf'] as String?,
    phone: props['phone'] as String?,
    email: props['email'] as String?,
    websiteUrl: web,
    bookingUrl: booking,
    servicesJson: servicesJson,
    notes: props['notes'] as String?,
    sourceUpdatedAtMs: sourceUpdatedAtMs,
  );
}
