import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../domain/weather/weather_forecast_view.dart';
import 'wind_legend_bar.dart';

/// Speed ring labels (kn) drawn on the rose.
const windRoseSpeedRingsKn = [10.0, 20.0, 30.0, 40.0];

/// Meteorological wind-from degrees → canvas radians for a downwind arrow.
/// [Icons.navigation] points up at 0 rad; 0° wind is from north (arrow south).
double windArrowCanvasRadians(double directionDeg) {
  if (directionDeg.isNaN) return 0;
  return (directionDeg + 180) * math.pi / 180;
}

/// Normalized radius (0–1) for [speedKn] on a 0–[maxKn] scale.
double windSpeedRingFactor(double speedKn, {double maxKn = 45}) {
  if (speedKn.isNaN || speedKn <= 0) return 0;
  return (speedKn / maxKn).clamp(0.0, 1.0);
}

/// Tip of the wind arrow relative to rose center (canvas coords, y-down).
Offset windArrowTipOffset(double directionDeg, double length) {
  final radians = windArrowCanvasRadians(directionDeg);
  return Offset(
    length * math.sin(radians),
    -length * math.cos(radians),
  );
}

/// 160×160 dp wind rose: cardinal ring, speed circles, downwind arrow.
class WindRoseWidget extends StatelessWidget {
  const WindRoseWidget({
    super.key,
    required this.hour,
    this.size = 160,
    this.maxKn = 45,
  });

  final HourlyWeatherPoint hour;
  final double size;
  final double maxKn;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final windColor = windColorForKn(hour.windSpeedKn, colors.windScale, maxKn: maxKn);

    return Semantics(
      label: hour.windDirectionDeg.isNaN
          ? 'Wind rose, direction unknown'
          : 'Wind rose, ${hour.windSpeedKn.toStringAsFixed(0)} knots '
              'from ${hour.windDirectionDeg.toStringAsFixed(0)} degrees',
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: WindRosePainter(
            directionDeg: hour.windDirectionDeg,
            speedKn: hour.windSpeedKn,
            windColor: windColor,
            ringColor: colors.textMuted.withValues(alpha: 0.35),
            labelColor: colors.textMuted,
            accentColor: colors.accentTeal,
            maxKn: maxKn,
          ),
          child: Center(
            child: Text(
              hour.windSpeedKn.isNaN
                  ? '—'
                  : hour.windSpeedKn.toStringAsFixed(0),
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WindRosePainter extends CustomPainter {
  WindRosePainter({
    required this.directionDeg,
    required this.speedKn,
    required this.windColor,
    required this.ringColor,
    required this.labelColor,
    required this.accentColor,
    this.maxKn = 45,
  });

  final double directionDeg;
  final double speedKn;
  final Color windColor;
  final Color ringColor;
  final Color labelColor;
  final Color accentColor;
  final double maxKn;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.shortestSide / 2 - 8;

    _drawCardinals(canvas, center, outerRadius);
    _drawSpeedRings(canvas, center, outerRadius);
    _drawCurrentSpeedRing(canvas, center, outerRadius);
    _drawWindArrow(canvas, center, outerRadius);
  }

  void _drawCardinals(Canvas canvas, Offset center, double outerRadius) {
    final border = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, outerRadius, border);

    const labels = ['N', 'E', 'S', 'W'];
    final textStyle = TextStyle(
      color: labelColor,
      fontSize: 11,
      fontWeight: FontWeight.w600,
    );
    for (var i = 0; i < 4; i++) {
      final angle = -math.pi / 2 + i * math.pi / 2;
      final tickEnd = center + Offset(
        outerRadius * math.cos(angle),
        outerRadius * math.sin(angle),
      );
      final tickStart = center + Offset(
        (outerRadius - 6) * math.cos(angle),
        (outerRadius - 6) * math.sin(angle),
      );
      canvas.drawLine(tickStart, tickEnd, border);

      final labelOffset = center + Offset(
        (outerRadius - 14) * math.cos(angle),
        (outerRadius - 14) * math.sin(angle),
      );
      _drawCenteredText(canvas, labels[i], labelOffset, textStyle);
    }
  }

  void _drawSpeedRings(Canvas canvas, Offset center, double outerRadius) {
    final ringPaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (final kn in windRoseSpeedRingsKn) {
      final factor = windSpeedRingFactor(kn, maxKn: maxKn);
      canvas.drawCircle(center, outerRadius * factor, ringPaint);
    }
  }

  void _drawCurrentSpeedRing(Canvas canvas, Offset center, double outerRadius) {
    if (speedKn.isNaN || speedKn <= 0) return;
    final factor = windSpeedRingFactor(speedKn, maxKn: maxKn);
    final paint = Paint()
      ..color = windColor.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(center, outerRadius * factor, paint);
  }

  void _drawWindArrow(Canvas canvas, Offset center, double outerRadius) {
    if (directionDeg.isNaN) return;

    final arrowLen = outerRadius * 0.72;
    final tip = center + windArrowTipOffset(directionDeg, arrowLen);
    final radians = windArrowCanvasRadians(directionDeg);
    final wing = Offset(
      10 * math.cos(radians + math.pi / 2),
      -10 * math.sin(radians + math.pi / 2),
    );

    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(tip.dx - wing.dx - 14 * math.sin(radians), tip.dy - wing.dy + 14 * math.cos(radians))
      ..lineTo(tip.dx + wing.dx - 14 * math.sin(radians), tip.dy + wing.dy + 14 * math.cos(radians))
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = windColor
        ..style = PaintingStyle.fill,
    );

    canvas.drawLine(
      center,
      tip,
      Paint()
        ..color = accentColor
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawCenteredText(
    Canvas canvas,
    String text,
    Offset center,
    TextStyle style,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      Offset(center.dx - painter.width / 2, center.dy - painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant WindRosePainter oldDelegate) {
    return oldDelegate.directionDeg != directionDeg ||
        oldDelegate.speedKn != speedKn ||
        oldDelegate.windColor != windColor ||
        oldDelegate.maxKn != maxKn;
  }
}
