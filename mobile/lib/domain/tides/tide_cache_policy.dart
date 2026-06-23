/// TTL for cached tide predictions (Step 42 — 7 days offline).
Duration tidesForecastTtl = const Duration(days: 7);

/// Reuses the same coarse grid as weather cache (~1 km).
String tidesGridKey(double lat, double lon) =>
    '${lat.toStringAsFixed(2)}_${lon.toStringAsFixed(2)}';

int tidesExpiresAtMs({
  required int fetchedAtMs,
  Duration ttl = const Duration(days: 7),
}) => fetchedAtMs + ttl.inMilliseconds;
