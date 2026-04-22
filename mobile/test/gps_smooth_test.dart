import 'package:captain_wrongel/domain/navigation/gps_smooth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const pipe = GpsSmoothing();

  test('loss of fix zeros output', () {
    final r = pipe.smooth(sogMps: 3, cogDegrees: 90, hasFix: false);
    expect(r.hasFix, false);
    expect(r.sogMps, 0);
    expect(r.cogDegrees, null);
  });

  test('very low speed clamps SOG and drops COG', () {
    final r = pipe.smooth(sogMps: 0.3, cogDegrees: 45, hasFix: true);
    expect(r.hasFix, true);
    expect(r.sogMps, 0);
    expect(r.cogDegrees, null);
  });

  test('sufficient speed preserves COG', () {
    final r = pipe.smooth(sogMps: 2.5, cogDegrees: 180, hasFix: true);
    expect(r.sogMps, 2.5);
    expect(r.cogDegrees, 180);
  });
}
