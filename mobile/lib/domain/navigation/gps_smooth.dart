/// Pure navigation helpers for GPS display (Фаза 1 — COG/SOG шум на малой скорости).
class SmoothedGps {
  const SmoothedGps({
    required this.sogMps,
    required this.cogDegrees,
    required this.hasFix,
  });

  /// Speed over ground, m/s (0 when treated as noise).
  final double sogMps;

  /// Course over ground, degrees [0,360), null when unreliable.
  final double? cogDegrees;

  final bool hasFix;
}

/// Applies conservative rules before feeding the chart UI.
class GpsSmoothing {
  const GpsSmoothing({
    this.lowSpeedMps = 0.55,
    this.cogUnreliableBelowMps = 1.05,
  });

  /// Below this SOG we show 0 knots and ignore COG noise (≈1 kt).
  final double lowSpeedMps;

  /// Below this SOG COG from GNSS is often meaningless.
  final double cogUnreliableBelowMps;

  SmoothedGps smooth({
    required double sogMps,
    required double? cogDegrees,
    required bool hasFix,
  }) {
    if (!hasFix) {
      return const SmoothedGps(sogMps: 0, cogDegrees: null, hasFix: false);
    }
    final sog = sogMps < lowSpeedMps ? 0.0 : sogMps;
    final cogOk = sog >= cogUnreliableBelowMps && sog > 0;
    final cog = cogOk ? cogDegrees : null;
    return SmoothedGps(sogMps: sog, cogDegrees: cog, hasFix: true);
  }
}
