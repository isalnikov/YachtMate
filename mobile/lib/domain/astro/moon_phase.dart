import 'package:flutter/material.dart';

/// Approximate moon phase bucket (0 = new … 7 = waning crescent).
int moonPhaseIndex(DateTime whenLocal) {
  const synodicDays = 29.53058867;
  final ref = DateTime.utc(2000, 1, 6, 18, 14);
  final days =
      whenLocal.toUtc().difference(ref).inMilliseconds / 86400000.0;
  final phase = (days % synodicDays) / synodicDays;
  return (phase * 8).floor().clamp(0, 7);
}

IconData moonPhaseIcon(int index) {
  return switch (index) {
    0 => Icons.brightness_2,
    1 => Icons.brightness_3,
    2 => Icons.brightness_4,
    3 => Icons.brightness_5,
    4 => Icons.brightness_6,
    5 => Icons.brightness_7,
    6 => Icons.brightness_6,
    _ => Icons.brightness_4,
  };
}
