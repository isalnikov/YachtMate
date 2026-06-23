import 'ais_vessel_category.dart';

/// Цель AIS для отображения на карте (Фаза 3).
class AisTarget {
  const AisTarget({
    required this.mmsi,
    required this.latitudeDeg,
    required this.longitudeDeg,
    required this.sogKnots,
    required this.cogDegrees,
    required this.updatedAtUtc,
    required this.category,
    this.name,
    this.trueHeadingDeg,
  });

  final int mmsi;
  final double latitudeDeg;
  final double longitudeDeg;
  final double sogKnots;
  final double cogDegrees;
  final DateTime updatedAtUtc;
  final AisVesselCategory category;
  final String? name;
  final int? trueHeadingDeg;

  String get displayName => name ?? aisDemoVesselName(mmsi);
}
