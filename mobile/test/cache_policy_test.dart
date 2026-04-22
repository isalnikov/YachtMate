import 'package:captain_wrongel/domain/weather/cache_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('weatherGridKey rounds to hundredths', () {
    expect(weatherGridKey(59.94321, 30.32109), '59.94_30.32');
  });

  test('TTL validity respects expiresAtMs', () {
    final now = DateTime.utc(2026, 4, 22, 12);
    expect(
      weatherCacheEntryValid(
        expiresAtMs: now.millisecondsSinceEpoch + 1,
        now: now,
      ),
      isTrue,
    );
    expect(
      weatherCacheEntryValid(
        expiresAtMs: now.millisecondsSinceEpoch - 1,
        now: now,
      ),
      isFalse,
    );
  });

  test('expiresAt equals fetchedAt + ttl', () {
    const t = 1000;
    expect(
      weatherExpiresAtMs(fetchedAtMs: t, ttl: const Duration(hours: 2)),
      t + 2 * 3600 * 1000,
    );
  });
}
