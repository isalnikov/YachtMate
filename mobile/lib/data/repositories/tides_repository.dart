import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../../domain/tides/tide_cache_policy.dart';
import '../../domain/tides/tide_demo_models.dart';
import '../../domain/tides/tide_station_bundle.dart';
import '../../domain/weather/cache_policy.dart';
import '../local/app_database.dart';
import '../remote/tides_api_client.dart';

/// Live tides (WorldTides / NOAA) with Drift cache and demo fallback (Step 42).
class TidesRepository {
  TidesRepository(
    this._db, {
    TidesApiClient? apiClient,
  }) : _api = apiClient ?? TidesApiClient();

  final AppDatabase _db;
  final TidesApiClient _api;

  void dispose() => _api.dispose();

  Future<TideStationBundle> loadTides(double lat, double lon) async {
    final key = tidesGridKey(lat, lon);
    final now = DateTime.now().toUtc();

    final row = await (_db.select(
      _db.tidesCacheRows,
    )..where((t) => t.gridKey.equals(key))).getSingleOrNull();

    if (row != null &&
        weatherCacheEntryValid(expiresAtMs: row.expiresAtMs, now: now)) {
      return _bundleFromJson(
        row.tidesJson,
        fetchedAtMs: row.fetchedAtMs,
        isStale: false,
      );
    }

    try {
      final station = await _api.fetchTides(lat, lon);
      if (station == null || station.events.isEmpty) {
        throw const TideFetchException('no station');
      }

      final fetchedAt = DateTime.now().toUtc();
      final ms = fetchedAt.millisecondsSinceEpoch;
      final json = _encodeStation(station);

      await _db
          .into(_db.tidesCacheRows)
          .insertOnConflictUpdate(
            TidesCacheRowsCompanion(
              gridKey: Value(key),
              tidesJson: Value(json),
              fetchedAtMs: Value(ms),
              expiresAtMs: Value(
                tidesExpiresAtMs(fetchedAtMs: ms, ttl: tidesForecastTtl),
              ),
            ),
          );

      return TideStationBundle(
        station: station,
        fetchedAtUtc: fetchedAt,
      );
    } catch (_) {
      if (row != null) {
        return _bundleFromJson(
          row.tidesJson,
          fetchedAtMs: row.fetchedAtMs,
          isStale: true,
        );
      }
      final demo = await loadDemoBundled();
      return TideStationBundle(
        station: demo,
        fetchedAtUtc: now,
        isDemo: true,
      );
    }
  }

  /// Illustrative schedule from bundled asset when API unavailable.
  Future<TideDemoStation> loadDemoBundled() async {
    final raw = await rootBundle.loadString('assets/tides/demo_tides.json');
    return _stationFromJson(raw);
  }

  TideStationBundle _bundleFromJson(
    String json, {
    required int fetchedAtMs,
    required bool isStale,
  }) {
    return TideStationBundle(
      station: _stationFromJson(json),
      fetchedAtUtc: DateTime.fromMillisecondsSinceEpoch(
        fetchedAtMs,
        isUtc: true,
      ),
      isStale: isStale,
    );
  }

  TideDemoStation _stationFromJson(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    final name = map['stationName'] as String? ?? 'Tides';
    final note = map['note'] as String? ?? '';
    final ev = <TideEvent>[];
    for (final e in map['events'] as List<dynamic>? ?? const []) {
      if (e is! Map<String, dynamic>) continue;
      ev.add(
        TideEvent(
          timeUtc: DateTime.parse(e['time'] as String).toUtc(),
          heightM: (e['heightM'] as num).toDouble(),
          isHigh: e['kind'] == 'high',
        ),
      );
    }
    return TideDemoStation(stationName: name, events: ev, note: note);
  }

  String _encodeStation(TideDemoStation station) {
    return jsonEncode({
      'stationName': station.stationName,
      'note': station.note,
      'events': [
        for (final e in station.events)
          {
            'time': e.timeUtc.toIso8601String(),
            'heightM': e.heightM,
            'kind': e.isHigh ? 'high' : 'low',
          },
      ],
    });
  }
}

class TideFetchException implements Exception {
  const TideFetchException(this.message);
  final String message;

  @override
  String toString() => 'TideFetchException: $message';
}
