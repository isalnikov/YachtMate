import 'package:drift/drift.dart';

/// Кэш JSON ответа Open-Meteo Forecast по ключу грубой сетки (Фаза 4).
@DataClassName('WeatherCacheRow')
class WeatherCacheRows extends Table {
  TextColumn get gridKey => text()();

  TextColumn get forecastJson => text()();

  IntColumn get fetchedAtMs => integer()();

  IntColumn get expiresAtMs => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {gridKey};
}
