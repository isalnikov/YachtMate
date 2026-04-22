import 'package:captain_wrongel/domain/weather/open_meteo_parse.dart';
import 'package:flutter_test/flutter_test.dart';

const _minimalFc = '''
{
  "hourly": {
    "time": ["2026-04-22T12:00"],
    "temperature_2m": [11.4],
    "precipitation": [0.1],
    "pressure_msl": [1015],
    "wind_speed_10m": [14],
    "wind_direction_10m": [220]
  }
}
''';

void main() {
  test('parseForecastJsonOnly builds hourly row', () {
    final b = parseForecastJsonOnly(
      forecastJson: _minimalFc,
      fetchedAtUtc: DateTime.utc(2026, 4, 22, 12),
    );
    expect(b.hourly, hasLength(1));
    expect(b.hourly.single.temperatureC, 11.4);
    expect(b.hourly.single.windSpeedKn, 14);
  });

  test('marine merges wave height by timestamp', () {
    const marine =
        '{"hourly":{"time":["2026-04-22T12:00"],"wave_height":[1.25]}}';
    final b = parseOpenMeteoCombined(
      forecastJson: _minimalFc,
      marineJson: marine,
      fetchedAtUtc: DateTime.utc(2026, 4, 22, 12),
    );
    expect(b.hourly.single.waveHeightM, 1.25);
  });
}
