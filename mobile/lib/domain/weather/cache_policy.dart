/// Политика TTL для кэша прогноза (Фаза 4).
Duration weatherForecastTtl = const Duration(hours: 1);

/// Ключ кэша: широта/долгота с шагом 0.01° (≈1 км).
String weatherGridKey(double lat, double lon) =>
    '${lat.toStringAsFixed(2)}_${lon.toStringAsFixed(2)}';

bool weatherCacheEntryValid({
  required int expiresAtMs,
  required DateTime now,
}) =>
    now.millisecondsSinceEpoch < expiresAtMs;

int weatherExpiresAtMs({
  required int fetchedAtMs,
  Duration ttl = const Duration(hours: 1),
}) =>
    fetchedAtMs + ttl.inMilliseconds;
