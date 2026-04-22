import 'dart:math' as math;

/// Порт ключевых формул [SunCalc](https://github.com/mourner/suncalc) (MIT).
/// Только для ориентировочных подсказок на палубе — не для официальной навигации.
class SunRiseSetUtc {
  const SunRiseSetUtc({required this.sunriseUtc, required this.sunsetUtc});

  final DateTime sunriseUtc;
  final DateTime sunsetUtc;
}

const _dayMs = 86400000.0;
const _j1970 = 2440588.0;
const _j2000 = 2451545.0;
const _j0 = 0.0009;

double _toJulian(DateTime date) =>
    date.millisecondsSinceEpoch / _dayMs - 0.5 + _j1970;

DateTime _fromJulian(double j) => DateTime.fromMillisecondsSinceEpoch(
      ((j + 0.5 - _j1970) * _dayMs).round(),
      isUtc: true,
    );

double _toDays(DateTime date) => _toJulian(date) - _j2000;

final double _e = math.pi / 180 * 23.4397;

double _declination(double l, double b) =>
    math.asin(math.sin(b) * math.cos(_e) + math.cos(b) * math.sin(_e) * math.sin(l));

double _solarMeanAnomaly(double d) =>
    math.pi / 180 * (357.5291 + 0.98560028 * d);

double _eclipticLongitude(double m) {
  final c =
      math.pi / 180 *
      (1.9148 * math.sin(m) + 0.02 * math.sin(2 * m) + 0.0003 * math.sin(3 * m));
  final p = math.pi / 180 * 102.9372;
  return m + c + p + math.pi;
}

double _julianCycle(double d, double lw) =>
    (d - _j0 - lw / (2 * math.pi)).roundToDouble();

double _approxTransit(double ht, double lw, double n) =>
    _j0 + (ht + lw) / (2 * math.pi) + n;

double _solarTransitJ(double ds, double m, double l) =>
    _j2000 + ds + 0.0053 * math.sin(m) - 0.0069 * math.sin(2 * l);

double _hourAngle(double h, double phi, double d) => math.acos(
      math.max(
        -1.0,
        math.min(1.0, (math.sin(h) - math.sin(phi) * math.sin(d)) /
                (math.cos(phi) * math.cos(d))),
      ),
    );

double _observerAngle(double heightM) => -2.076 * math.sqrt(heightM) / 60;

double _getSetJ(
  double h,
  double lw,
  double phi,
  double dec,
  double n,
  double m,
  double l,
) {
  final w = _hourAngle(h, phi, dec);
  final a = _approxTransit(w, lw, n);
  return _solarTransitJ(a, m, l);
}

/// Восход и закат для календарной даты [whenUtc] (обычно полдень UTC этой даты).
/// [heightM] — высота глаза над горизонтом в метрах.
SunRiseSetUtc approximateSunriseSunsetUtc({
  required double latDeg,
  required double lonDeg,
  required DateTime whenUtc,
  double heightM = 2.0,
}) {
  final lw = math.pi / 180 * -lonDeg;
  final phi = math.pi / 180 * latDeg;
  final dh = _observerAngle(heightM);
  final h0 = (-0.833 + dh) * math.pi / 180;

  final d = _toDays(whenUtc);
  final n = _julianCycle(d, lw);
  final ds = _approxTransit(0, lw, n);
  final m = _solarMeanAnomaly(ds);
  final le = _eclipticLongitude(m);
  final dec = _declination(le, 0);
  final jNoon = _solarTransitJ(ds, m, le);

  final jSet = _getSetJ(h0, lw, phi, dec, n, m, le);
  final jRise = jNoon - (jSet - jNoon);

  return SunRiseSetUtc(
    sunriseUtc: _fromJulian(jRise),
    sunsetUtc: _fromJulian(jSet),
  );
}
