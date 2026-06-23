import 'tide_demo_models.dart';

/// Tide station data with cache / source metadata (Step 42).
class TideStationBundle {
  const TideStationBundle({
    required this.station,
    required this.fetchedAtUtc,
    this.isStale = false,
    this.isDemo = false,
  });

  final TideDemoStation station;
  final DateTime fetchedAtUtc;
  final bool isStale;
  final bool isDemo;
}
