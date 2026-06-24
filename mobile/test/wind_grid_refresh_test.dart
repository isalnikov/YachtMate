import 'package:captain_wrongel/domain/weather/wind_grid_refresh.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('shouldRefreshWindGrid false when center barely moves', () {
    expect(
      shouldRefreshWindGrid(
        fromLat: 36.0,
        fromLon: 29.0,
        toLat: 36.01,
        toLon: 29.01,
      ),
      isFalse,
    );
  });

  test('shouldRefreshWindGrid true when center crosses threshold', () {
    expect(
      shouldRefreshWindGrid(
        fromLat: 36.0,
        fromLon: 29.0,
        toLat: 36.05,
        toLon: 29.0,
      ),
      isTrue,
    );
  });
}
