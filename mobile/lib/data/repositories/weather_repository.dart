import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;

import '../../core/energy_profile_controller.dart';
import '../../domain/weather/cache_policy.dart';
import '../../domain/weather/open_meteo_parse.dart';
import '../../domain/weather/weather_forecast_view.dart';
import '../../domain/weather/wind_grid.dart';
import '../local/app_database.dart';

/// Open-Meteo Forecast + Marine (волна), SQLite-кэш с TTL (Фаза 4).
class WeatherRepository {
  WeatherRepository(this._db, {http.Client? httpClient, Duration? timeout})
    : _http = httpClient ?? http.Client(),
      _ownsHttpClient = httpClient == null,
      _timeout = timeout ?? const Duration(seconds: 18);

  final AppDatabase _db;
  final http.Client _http;
  final bool _ownsHttpClient;
  final Duration _timeout;

  void dispose() {
    if (_ownsHttpClient) {
      _http.close();
    }
  }

  Uri _forecastUri(double lat, double lon) => Uri.parse(
    'https://api.open-meteo.com/v1/forecast'
    '?latitude=${lat.toString()}'
    '&longitude=${lon.toString()}'
    '&hourly=temperature_2m,precipitation,pressure_msl,'
    'wind_speed_10m,wind_direction_10m,wind_gusts_10m'
    '&wind_speed_unit=kn'
    '&forecast_days=4',
  );

  Uri _marineUri(double lat, double lon) => Uri.parse(
    'https://marine-api.open-meteo.com/v1/marine'
    '?latitude=${lat.toString()}'
    '&longitude=${lon.toString()}'
    '&hourly=wave_height'
    '&forecast_days=4',
  );

  Future<WeatherForecastBundle> loadForecast(double lat, double lon) async {
    final key = weatherGridKey(lat, lon);
    final now = DateTime.now().toUtc();

    final row = await (_db.select(
      _db.weatherCacheRows,
    )..where((t) => t.gridKey.equals(key))).getSingleOrNull();

    if (row != null &&
        weatherCacheEntryValid(expiresAtMs: row.expiresAtMs, now: now)) {
      return parseForecastJsonOnly(
        forecastJson: row.forecastJson,
        fetchedAtUtc: DateTime.fromMillisecondsSinceEpoch(
          row.fetchedAtMs,
          isUtc: true,
        ),
      );
    }

    try {
      final fcResp = await _http.get(_forecastUri(lat, lon)).timeout(_timeout);
      if (fcResp.statusCode != 200) {
        throw HttpWeatherException(fcResp.statusCode);
      }

      String? marineBody;
      try {
        final mrResp = await _http.get(_marineUri(lat, lon)).timeout(_timeout);
        if (mrResp.statusCode == 200) marineBody = mrResp.body;
      } catch (_) {
        marineBody = null;
      }

      final fetchedAt = DateTime.now().toUtc();
      final ms = fetchedAt.millisecondsSinceEpoch;

      await _db
          .into(_db.weatherCacheRows)
          .insertOnConflictUpdate(
            WeatherCacheRowsCompanion(
              gridKey: Value(key),
              forecastJson: Value(fcResp.body),
              fetchedAtMs: Value(ms),
              expiresAtMs: Value(
                weatherExpiresAtMs(fetchedAtMs: ms, ttl: weatherForecastTtl),
              ),
            ),
          );

      return parseOpenMeteoCombined(
        forecastJson: fcResp.body,
        marineJson: marineBody,
        fetchedAtUtc: fetchedAt,
      );
    } catch (_) {
      if (row != null) {
        return parseForecastJsonOnly(
          forecastJson: row.forecastJson,
          fetchedAtUtc: DateTime.fromMillisecondsSinceEpoch(
            row.fetchedAtMs,
            isUtc: true,
          ),
          isStale: true,
        );
      }
      rethrow;
    }
  }

  /// 3×3 wind grid around [centerLat]/[centerLon] from cached Open-Meteo points (step 47).
  Future<WindGridBundle> loadWindGrid(
    double centerLat,
    double centerLon, {
    EnergyProfile profile = EnergyProfile.passage,
  }) async {
    const stepDeg = 0.05;
    final half = switch (profile) {
      EnergyProfile.eco => 1,
      EnergyProfile.passage => 1,
      EnergyProfile.sport => 2,
    };

    final cells = <WindGridCell>[];
    var anyStale = false;
    final now = DateTime.now().toUtc();

    for (var di = -half; di <= half; di++) {
      for (var dj = -half; dj <= half; dj++) {
        final lat = centerLat + di * stepDeg;
        final lon = centerLon + dj * stepDeg;
        final bundle = await loadForecast(lat, lon);
        if (bundle.isStale) anyStale = true;
        final hour = _nearestHour(bundle.hourly, now);
        if (hour == null) continue;
        cells.add(
          WindGridCell(
            lat: lat,
            lon: lon,
            windSpeedKn: hour.windSpeedKn,
            windDirectionDeg: hour.windDirectionDeg,
          ),
        );
      }
    }

    return WindGridBundle(
      fetchedAtUtc: now,
      cells: cells,
      isStale: anyStale,
    );
  }

  HourlyWeatherPoint? _nearestHour(List<HourlyWeatherPoint> hourly, DateTime now) {
    if (hourly.isEmpty) return null;
    HourlyWeatherPoint? best;
    var bestDelta = 1 << 62;
    for (final h in hourly) {
      final d = (h.timeUtc.difference(now)).inMinutes.abs();
      if (d < bestDelta) {
        bestDelta = d;
        best = h;
      }
    }
    return best;
  }
}

class HttpWeatherException implements Exception {
  HttpWeatherException(this.statusCode);
  final int statusCode;

  @override
  String toString() => 'HTTP $statusCode';
}
