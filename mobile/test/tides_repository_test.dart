import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/remote/tides_api_client.dart';
import 'package:captain_wrongel/data/repositories/tides_repository.dart';
import 'package:captain_wrongel/domain/tides/tide_cache_policy.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _noaaStationsJson = '''
{
  "count": 1,
  "stations": [
    {
      "id": "8418150",
      "name": "Portland, Casco Bay",
      "lat": 43.6581,
      "lng": -70.2442
    }
  ]
}
''';

const _noaaPredictionsJson = '''
{
  "predictions": [
    {"t": "2026-04-22 03:15", "v": "3.4", "type": "H"},
    {"t": "2026-04-22 09:40", "v": "0.8", "type": "L"},
    {"t": "2026-04-22 15:55", "v": "3.1", "type": "H"},
    {"t": "2026-04-22 22:10", "v": "1.0", "type": "L"}
  ]
}
''';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads from NOAA and caches by grid key', () async {
    var calls = 0;
    final client = MockClient((request) async {
      calls++;
      if (request.url.path.contains('stations.json')) {
        return http.Response(_noaaStationsJson, 200);
      }
      if (request.url.path.contains('predictions')) {
        return http.Response(_noaaPredictionsJson, 200);
      }
      return http.Response('not found', 404);
    });

    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final api = TidesApiClient(httpClient: client);
    addTearDown(api.dispose);
    final repo = TidesRepository(db, apiClient: api);

    const lat = 43.66;
    const lon = -70.25;
    final key = tidesGridKey(lat, lon);

    final a = await repo.loadTides(lat, lon);
    expect(a.isDemo, isFalse);
    expect(a.isStale, isFalse);
    expect(a.station.events, hasLength(4));
    expect(a.station.stationName, contains('NOAA'));
    expect(calls, 2);

    final b = await repo.loadTides(lat, lon);
    expect(b.station.events.first.heightM, closeTo(3.4, 0.01));
    expect(calls, 2);

    final row = await (db.select(
      db.tidesCacheRows,
    )..where((t) => t.gridKey.equals(key))).getSingle();
    expect(row.tidesJson, contains('NOAA'));
  });

  test('returns stale cache when network fails', () async {
    final client = MockClient((request) async {
      return http.Response('error', 500);
    });

    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    const lat = 1.0;
    const lon = 2.0;
    const cachedJson = '''
{
  "stationName": "Cached Harbor",
  "note": "cached",
  "events": [
    {"time": "2026-04-22T03:15:00Z", "heightM": 2.0, "kind": "high"}
  ]
}
''';

    await db
        .into(db.tidesCacheRows)
        .insert(
          TidesCacheRowsCompanion.insert(
            gridKey: tidesGridKey(lat, lon),
            tidesJson: cachedJson,
            fetchedAtMs: DateTime.utc(2020).millisecondsSinceEpoch,
            expiresAtMs: DateTime.utc(2020).millisecondsSinceEpoch,
          ),
        );

    final api = TidesApiClient(httpClient: client);
    addTearDown(api.dispose);
    final repo = TidesRepository(db, apiClient: api);

    final r = await repo.loadTides(lat, lon);
    expect(r.isStale, isTrue);
    expect(r.station.stationName, 'Cached Harbor');
    expect(r.station.events, hasLength(1));
  });

  test('falls back to bundled demo when API and cache unavailable', () async {
    final client = MockClient((request) async {
      return http.Response('{"stations":[]}', 200);
    });

    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final api = TidesApiClient(httpClient: client, worldTidesApiKey: '');
    addTearDown(api.dispose);
    final repo = TidesRepository(db, apiClient: api);

    final r = await repo.loadTides(36.65, 29.12);
    expect(r.isDemo, isTrue);
    expect(r.station.stationName, contains('Demo'));
    expect(r.station.events, isNotEmpty);
  });
}
