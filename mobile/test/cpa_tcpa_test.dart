import 'package:captain_wrongel/domain/ais/cpa_tcpa.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parallel tracks: CPA equals lateral offset, TCPA scales with distance', () {
    final r = computeCpaTcpa(
      ownLatDeg: 60.0,
      ownLonDeg: 20.0,
      ownCogDeg: 0,
      ownSogKn: 10,
      tgtLatDeg: 60.0,
      tgtLonDeg: 20.02,
      tgtCogDeg: 0,
      tgtSogKn: 10,
    );
    expect(r.tcpaHours.isInfinite, isTrue);
    expect(r.cpaNm, greaterThan(0));
  });

  test('head-on: CPA small and TCPA finite', () {
    final r = computeCpaTcpa(
      ownLatDeg: 60.0,
      ownLonDeg: 20.0,
      ownCogDeg: 0,
      ownSogKn: 10,
      tgtLatDeg: 60.1,
      tgtLonDeg: 20.0,
      tgtCogDeg: 180,
      tgtSogKn: 10,
    );
    expect(r.cpaNm, closeTo(0, 1e-6));
    expect(r.tcpaHours.isFinite, isTrue);
    expect(r.tcpaHours, greaterThan(0));
  });
}
