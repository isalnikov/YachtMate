import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';

/// Default compass rose diameter (design step 34).
const kCompassDialSize = 200.0;

/// 200×200 dp magnetic heading dial with cardinal labels and lubber line.
class CompassDial extends StatelessWidget {
  const CompassDial({
    super.key,
    this.headingDeg,
    this.size = kCompassDialSize,
  });

  final double? headingDeg;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final heading = headingDeg;
    final headingLabel = heading == null ? '—' : '${heading.round()}°';

    return Semantics(
      label: heading == null
          ? 'Compass heading unknown'
          : 'Compass heading ${heading.round()} degrees',
      child: SizedBox(
        key: const Key('compass_dial'),
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (heading != null)
              Transform.rotate(
                angle: -heading * math.pi / 180,
                child: CustomPaint(
                  size: Size.square(size),
                  painter: CompassDialPainter(
                    ringColor: colors.textMuted.withValues(alpha: 0.4),
                    tickColor: colors.textMuted.withValues(alpha: 0.55),
                    northColor: colors.accentTeal,
                    labelColor: colors.textMuted,
                  ),
                ),
              )
            else
              CustomPaint(
                size: Size.square(size),
                painter: CompassDialPainter(
                  ringColor: colors.textMuted.withValues(alpha: 0.4),
                  tickColor: colors.textMuted.withValues(alpha: 0.55),
                  northColor: colors.accentTeal,
                  labelColor: colors.textMuted,
                ),
              ),
            CustomPaint(
              size: Size.square(size),
              painter: _LubberLinePainter(color: colors.accentOrange),
            ),
            Text(
              headingLabel,
              style: CwTypography.display(color: colors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class CompassDialPainter extends CustomPainter {
  CompassDialPainter({
    required this.ringColor,
    required this.tickColor,
    required this.northColor,
    required this.labelColor,
  });

  final Color ringColor;
  final Color tickColor;
  final Color northColor;
  final Color labelColor;

  static const _cardinals = ['N', 'E', 'S', 'W'];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.shortestSide / 2 - 10;

    final ringPaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, outerRadius, ringPaint);

    final tickPaint = Paint()
      ..color = tickColor
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (var deg = 0; deg < 360; deg += 30) {
      final angle = _degToCanvasRad(deg.toDouble());
      final isMajor = deg % 90 == 0;
      final tickLen = isMajor ? 10.0 : 5.0;
      final start = center + Offset(
        (outerRadius - tickLen) * math.cos(angle),
        (outerRadius - tickLen) * math.sin(angle),
      );
      final end = center + Offset(
        outerRadius * math.cos(angle),
        outerRadius * math.sin(angle),
      );
      canvas.drawLine(start, end, tickPaint);
    }

    for (var i = 0; i < _cardinals.length; i++) {
      final deg = i * 90.0;
      final angle = _degToCanvasRad(deg);
      final isNorth = i == 0;
      final style = TextStyle(
        color: isNorth ? northColor : labelColor,
        fontSize: isNorth ? 14 : 12,
        fontWeight: isNorth ? FontWeight.w800 : FontWeight.w600,
      );
      final labelOffset = center + Offset(
        (outerRadius - 22) * math.cos(angle),
        (outerRadius - 22) * math.sin(angle),
      );
      _drawCenteredText(canvas, _cardinals[i], labelOffset, style);
    }
  }

  double _degToCanvasRad(double deg) => (deg - 90) * math.pi / 180;

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
  bool shouldRepaint(covariant CompassDialPainter oldDelegate) {
    return oldDelegate.ringColor != ringColor ||
        oldDelegate.tickColor != tickColor ||
        oldDelegate.northColor != northColor ||
        oldDelegate.labelColor != labelColor;
  }
}

class _LubberLinePainter extends CustomPainter {
  const _LubberLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final top = 6.0;
    final path = Path()
      ..moveTo(centerX, top)
      ..lineTo(centerX - 8, top + 14)
      ..lineTo(centerX + 8, top + 14)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _LubberLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
