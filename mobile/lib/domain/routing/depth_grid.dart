import 'dart:math' as math;

/// Регулярная прямоугольная сетка глубин [м]. Индекс (0,0) — юго-западный угол.
class DepthGrid {
  DepthGrid({
    required this.rows,
    required this.cols,
    required this.depthM,
    required this.originLatDeg,
    required this.originLonDeg,
    required this.latStepDeg,
    required this.lonStepDeg,
  }) : assert(depthM.length == rows),
       assert(depthM.every((row) => row.length == cols));

  final int rows;
  final int cols;
  final List<List<double>> depthM;

  /// Юго-западный угол сетки (нижняя левая ячейка — центр или угол по выбору; здесь угол ячейки).
  final double originLatDeg;
  final double originLonDeg;
  final double latStepDeg;
  final double lonStepDeg;

  double? depthAtCell(int row, int col) {
    if (row < 0 || col < 0 || row >= rows || col >= cols) return null;
    return depthM[row][col];
  }

  /// Центр ячейки.
  (double lat, double lon) cellCenter(int row, int col) {
    final lat = originLatDeg + (row + 0.5) * latStepDeg;
    final lon = originLonDeg + (col + 0.5) * lonStepDeg;
    return (lat, lon);
  }

  /// Ближайшие индексы ячейки для точки (snap к центрам).
  (int row, int col)? nearestCell(double latDeg, double lonDeg) {
    final j = ((lonDeg - originLonDeg) / lonStepDeg).floor();
    final i = ((latDeg - originLatDeg) / latStepDeg).floor();
    if (i < 0 || j < 0 || i >= rows || j >= cols) return null;
    return (i, j);
  }

  double haversineMeters(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371000.0;
    final p1 = lat1 * math.pi / 180;
    final p2 = lat2 * math.pi / 180;
    final dp = (lat2 - lat1) * math.pi / 180;
    final dl = (lon2 - lon1) * math.pi / 180;
    final h =
        math.sin(dp / 2) * math.sin(dp / 2) +
        math.cos(p1) * math.cos(p2) * math.sin(dl / 2) * math.sin(dl / 2);
    return 2 * r * math.asin(math.min(1.0, math.sqrt(h)));
  }
}
