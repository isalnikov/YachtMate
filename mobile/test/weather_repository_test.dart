import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/weather_repository.dart';
import 'package:captain_wrongel/domain/weather/cache_policy.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _fcJson = '''
{
  "hourly": {
    "time": ["2026-04-22T12:00"],
    "temperature_2m": [10],
    "precipitation": [0],
    "pressure_msl": [1013],
    "wind_speed_10m": [5],
    "wind_direction_10m": [90]
  }
}
''';

void main() {
  test('loads from network and caches by grid key', () async {
    var calls = 0;
    final client = MockClient((request) async {
      calls++;
      if (request.url.host.contains('marine-api')) {
        return http.Response(
          '{"hourly":{"time":["2026-04-22T12:00"],"wave_height":[0.5]}}',
          200,
        );
      }
      return http.Response(_fcJson, 200);
    });

    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = WeatherRepository(db, httpClient: client);

    final lat = 59.94;
    final lon = 30.32;
    final k = weatherGridKey(lat, lon);

    final a = await repo.loadForecast(lat, lon);
    expect(a.hourly, isNotEmpty);
    expect(calls, 2);

    final b = await repo.loadForecast(lat, lon);
    expect(b.hourly.first.temperatureC, 10);
    expect(calls, 2);

    final row = await (db.select(
      db.weatherCacheRows,
    )..where((t) => t.gridKey.equals(k))).getSingle();
    expect(row.forecastJson, contains('temperature_2m'));
  });

  test('returns stale cache when network fails', () async {
    final client = MockClient((request) async {
      return http.Response('error', 500);
    });

    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await db
        .into(db.weatherCacheRows)
        .insert(
          WeatherCacheRowsCompanion.insert(
            gridKey: weatherGridKey(1, 2),
            forecastJson: _fcJson,
            fetchedAtMs: DateTime.utc(2020).millisecondsSinceEpoch,
            expiresAtMs: DateTime.utc(2020).millisecondsSinceEpoch,
          ),
        );

    final repo = WeatherRepository(db, httpClient: client);
    final r = await repo.loadForecast(1.0, 2.0);
    expect(r.isStale, isTrue);
    expect(r.hourly, isNotEmpty);
  });
}
