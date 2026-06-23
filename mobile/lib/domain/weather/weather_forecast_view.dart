/// Упрощённое представление почасового прогноза для UI (Фаза 4).
class HourlyWeatherPoint {
  const HourlyWeatherPoint({
    required this.timeUtc,
    required this.temperatureC,
    required this.precipitationMm,
    required this.pressureHpa,
    required this.windSpeedKn,
    required this.windDirectionDeg,
    this.windGustKn,
    this.waveHeightM,
  });

  final DateTime timeUtc;
  final double temperatureC;
  final double precipitationMm;
  final double pressureHpa;
  final double windSpeedKn;
  final double windDirectionDeg;
  final double? windGustKn;
  final double? waveHeightM;
}

class WeatherForecastBundle {
  const WeatherForecastBundle({
    required this.fetchedAtUtc,
    required this.isStale,
    required this.hourly,
  });

  final DateTime fetchedAtUtc;
  final bool isStale;
  final List<HourlyWeatherPoint> hourly;
}
