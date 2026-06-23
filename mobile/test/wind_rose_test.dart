import 'dart:math' as math;

import 'package:captain_wrongel/features/weather/widgets/wind_rose.dart';
import 'package:flutter_test/flutter_test.dart';

double _normalizeRadians(double radians) {
  final twoPi = 2 * math.pi;
  var n = radians % twoPi;
  if (n < 0) n += twoPi;
  return n;
}

void _expectAngle(double actual, double expected) {
  expect(_normalizeRadians(actual), closeTo(_normalizeRadians(expected), 1e-9));
}

void main() {
  group('windArrowCanvasRadians', () {
    test('north wind points south (pi rad)', () {
      _expectAngle(windArrowCanvasRadians(0), math.pi);
    });

    test('east wind points west (3pi/2 rad)', () {
      _expectAngle(windArrowCanvasRadians(90), 3 * math.pi / 2);
    });

    test('south wind points north (0 rad)', () {
      _expectAngle(windArrowCanvasRadians(180), 0);
    });

    test('west wind points east (pi/2 rad)', () {
      _expectAngle(windArrowCanvasRadians(270), math.pi / 2);
    });

    test('NaN direction yields zero radians', () {
      expect(windArrowCanvasRadians(double.nan), 0);
    });
  });

  group('windSpeedRingFactor', () {
    test('maps half of maxKn to 0.5', () {
      expect(windSpeedRingFactor(22.5, maxKn: 45), 0.5);
    });

    test('clamps above maxKn to 1', () {
      expect(windSpeedRingFactor(60, maxKn: 45), 1);
    });

    test('zero or negative speed yields 0', () {
      expect(windSpeedRingFactor(0), 0);
      expect(windSpeedRingFactor(-5), 0);
    });

    test('NaN speed yields 0', () {
      expect(windSpeedRingFactor(double.nan), 0);
    });
  });

  group('windArrowTipOffset', () {
    test('north wind tip is below center', () {
      final tip = windArrowTipOffset(0, 50);
      expect(tip.dx, closeTo(0, 1e-9));
      expect(tip.dy, closeTo(50, 1e-9));
    });

    test('east wind tip is left of center', () {
      final tip = windArrowTipOffset(90, 40);
      expect(tip.dx, closeTo(-40, 1e-9));
      expect(tip.dy, closeTo(0, 1e-9));
    });

    test('tip length matches requested radius', () {
      final tip = windArrowTipOffset(45, 30);
      expect(tip.distance, closeTo(30, 1e-9));
    });
  });
}
