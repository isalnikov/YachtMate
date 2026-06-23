/// One wind sample on a lat/lon grid for map overlay (step 47).
class WindGridCell {
  const WindGridCell({
    required this.lat,
    required this.lon,
    required this.windSpeedKn,
    required this.windDirectionDeg,
  });

  final double lat;
  final double lon;
  final double windSpeedKn;

  /// Meteorological direction — wind is coming FROM this bearing (degrees).
  final double windDirectionDeg;
}

class WindGridBundle {
  const WindGridBundle({
    required this.fetchedAtUtc,
    required this.cells,
    this.isStale = false,
  });

  final DateTime fetchedAtUtc;
  final List<WindGridCell> cells;
  final bool isStale;

  static final empty = WindGridBundle(
    fetchedAtUtc: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    cells: const [],
  );
}
