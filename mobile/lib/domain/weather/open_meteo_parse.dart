import 'dart:convert';

import 'weather_forecast_view.dart';

/// Разбор ответов Open-Meteo Forecast + опционально Marine API.
WeatherForecastBundle parseOpenMeteoCombined({
  required String forecastJson,
  String? marineJson,
  required DateTime fetchedAtUtc,
  bool isStale = false,
}) {
  final fc = jsonDecode(forecastJson) as Map<String, dynamic>;
  final hourly = fc['hourly'] as Map<String, dynamic>? ?? {};
  final times = (hourly['time'] as List<dynamic>? ?? []).cast<String>();
  final temp = _doubles(hourly['temperature_2m']);
  final precip = _doubles(hourly['precipitation']);
  final pres = _doubles(hourly['pressure_msl']);
  final wsk = _doubles(hourly['wind_speed_10m']);
  final wdir = _doubles(hourly['wind_direction_10m']);

  Map<String, double>? wavesByTime;
  if (marineJson != null) {
    final mj = jsonDecode(marineJson) as Map<String, dynamic>;
    final mh = mj['hourly'] as Map<String, dynamic>? ?? {};
    final mt = (mh['time'] as List<dynamic>? ?? []).cast<String>();
    final wh = _doubles(mh['wave_height']);
    wavesByTime = {
      for (var i = 0; i < mt.length && i < wh.length; i++)
        mt[i]: wh[i],
    };
  }

  final rows = <HourlyWeatherPoint>[];
  for (var i = 0; i < times.length; i++) {
    final t = DateTime.parse(times[i]);
    rows.add(
      HourlyWeatherPoint(
        timeUtc: t.toUtc(),
        temperatureC: _at(temp, i),
        precipitationMm: _at(precip, i),
        pressureHpa: _at(pres, i),
        windSpeedKn: _at(wsk, i),
        windDirectionDeg: _at(wdir, i),
        waveHeightM: wavesByTime?[times[i]],
      ),
    );
  }

  return WeatherForecastBundle(
    fetchedAtUtc: fetchedAtUtc.toUtc(),
    isStale: isStale,
    hourly: rows,
  );
}

WeatherForecastBundle parseForecastJsonOnly({
  required String forecastJson,
  required DateTime fetchedAtUtc,
  bool isStale = false,
}) =>
    parseOpenMeteoCombined(
      forecastJson: forecastJson,
      fetchedAtUtc: fetchedAtUtc,
      isStale: isStale,
    );

List<double> _doubles(dynamic v) {
  if (v is! List<dynamic>) return [];
  return v.map((e) => (e as num).toDouble()).toList();
}

double _at(List<double> a, int i) =>
    i < a.length ? a[i] : double.nan;
