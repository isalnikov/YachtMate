import 'dart:math' as math;

/// CPA (ближайший подход) и TCPA (время до CPA) между двумя целями.
///
/// Вычисление на касательной плоскости (локальная плоскость на средней широте).
/// Входные углы в градусах \[0..360), скорости — узлы.
class CpaTcpaResult {
  const CpaTcpaResult({
    required this.cpaNm,
    required this.tcpaHours,
  });

  /// Closest-point-of-approach distance (морские мили).
  final double cpaNm;

  /// Время до CPA в часах; `<0` — траектории уже разошлись минимально в прошлом.
  final double tcpaHours;

  /// Не определено (нет относительной скорости параллельные курсы того же места).
  bool get isUndefined => tcpaHours.isInfinite;
}

/// Земной радиус для локальной метрической аппроксимации [м].
const double _earthRadiusM = 6371000;

CpaTcpaResult computeCpaTcpa({
  required double ownLatDeg,
  required double ownLonDeg,
  required double ownCogDeg,
  required double ownSogKn,
  required double tgtLatDeg,
  required double tgtLonDeg,
  required double tgtCogDeg,
  required double tgtSogKn,
}) {
  final toRad = math.pi / 180;

  final latM = (ownLatDeg + tgtLatDeg) / 2 * toRad;
  final dx = _earthRadiusM * (tgtLonDeg - ownLonDeg) * toRad * math.cos(latM);
  final dy = _earthRadiusM * (tgtLatDeg - ownLatDeg) * toRad;

  final vnO = knotsToMs(ownSogKn) * math.cos(ownCogDeg * toRad);
  final veO = knotsToMs(ownSogKn) * math.sin(ownCogDeg * toRad);
  final vnT = knotsToMs(tgtSogKn) * math.cos(tgtCogDeg * toRad);
  final veT = knotsToMs(tgtSogKn) * math.sin(tgtCogDeg * toRad);

  final vrN = vnT - vnO;
  final vrE = veT - veO;

  final vv = vrN * vrN + vrE * vrE;
  if (vv < 1e-12) {
    final distM = math.sqrt(dx * dx + dy * dy);
    return CpaTcpaResult(cpaNm: distM / 1852.0, tcpaHours: double.infinity);
  }

  /// `R·V` для `R=(dx` восток`, dy` север`) и `V=(vrE, vrN)`.
  final tcpaSec = -(dx * vrE + dy * vrN) / vv;
  final tcpaH = tcpaSec / 3600.0;

  final cpaEastM = dx + vrE * tcpaSec;
  final cpaNorthM = dy + vrN * tcpaSec;
  final cpaM = math.sqrt(cpaEastM * cpaEastM + cpaNorthM * cpaNorthM);

  return CpaTcpaResult(cpaNm: cpaM / 1852.0, tcpaHours: tcpaH);
}

double knotsToMs(double kn) => kn * 0.514444;
