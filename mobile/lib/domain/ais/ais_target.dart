/// Цель AIS для отображения на карте (Фаза 3).
class AisTarget {
  const AisTarget({
    required this.mmsi,
    required this.latitudeDeg,
    required this.longitudeDeg,
    required this.sogKnots,
    required this.cogDegrees,
    required this.updatedAtUtc,
  });

  final int mmsi;
  final double latitudeDeg;
  final double longitudeDeg;
  final double sogKnots;
  final double cogDegrees;
  final DateTime updatedAtUtc;
}
