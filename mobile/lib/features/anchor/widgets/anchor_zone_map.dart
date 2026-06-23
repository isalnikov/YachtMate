import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/anchor_watch_controller.dart';
import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../domain/anchor/geo.dart';
import '../../../l10n/app_localizations.dart';

/// Mini map preview: anchor circle, vessel dot, grey drift trail.
class AnchorZoneMap extends StatelessWidget {
  const AnchorZoneMap({
    super.key,
    required this.state,
    this.height = 200,
  });

  final AnchorWatchState state;
  final double height;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(CwRadius.md),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: state.hasAnchor
            ? CustomPaint(
                painter: _AnchorZonePainter(
                  anchorLat: state.anchorLat!,
                  anchorLon: state.anchorLon!,
                  radiusM: state.radiusM,
                  currentLat: state.currentLat,
                  currentLon: state.currentLon,
                  driftHistory: state.driftHistory,
                  zoneColor: colors.accentTeal,
                  trailColor: colors.textMuted.withValues(alpha: 0.55),
                  vesselColor: colors.accentOrange,
                  anchorColor: colors.textPrimary,
                  fillColor: colors.accentTeal.withValues(alpha: 0.08),
                  backgroundColor: colors.panelBlue,
                ),
              )
            : ColoredBox(
                color: colors.panelBlue,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(CwSpacing.m),
                    child: Text(
                      l10n.anchorWatchMapPlaceholder,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _AnchorZonePainter extends CustomPainter {
  _AnchorZonePainter({
    required this.anchorLat,
    required this.anchorLon,
    required this.radiusM,
    required this.currentLat,
    required this.currentLon,
    required this.driftHistory,
    required this.zoneColor,
    required this.trailColor,
    required this.vesselColor,
    required this.anchorColor,
    required this.fillColor,
    required this.backgroundColor,
  });

  final double anchorLat;
  final double anchorLon;
  final double radiusM;
  final double? currentLat;
  final double? currentLon;
  final List<AnchorDriftPoint> driftHistory;
  final Color zoneColor;
  final Color trailColor;
  final Color vesselColor;
  final Color anchorColor;
  final Color fillColor;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = backgroundColor);

    final center = Offset(size.width / 2, size.height / 2);
    final extentM = _maxExtentM();
    final pxPerM = (math.min(size.width, size.height) * 0.42) / extentM;

    Offset toCanvas(double lat, double lon) {
      final o = anchorOffsetMeters(
        anchorLat: anchorLat,
        anchorLon: anchorLon,
        lat: lat,
        lon: lon,
      );
      return Offset(
        center.dx + o.eastM * pxPerM,
        center.dy - o.northM * pxPerM,
      );
    }

    final zoneRadiusPx = radiusM * pxPerM;
    canvas.drawCircle(center, zoneRadiusPx, Paint()..color = fillColor);
    canvas.drawCircle(
      center,
      zoneRadiusPx,
      Paint()
        ..color = zoneColor.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    if (driftHistory.length >= 2) {
      final path = Path();
      final first = toCanvas(driftHistory.first.lat, driftHistory.first.lon);
      path.moveTo(first.dx, first.dy);
      for (var i = 1; i < driftHistory.length; i++) {
        final p = driftHistory[i];
        final pt = toCanvas(p.lat, p.lon);
        path.lineTo(pt.dx, pt.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = trailColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    _drawAnchorMark(canvas, center, anchorColor);

    if (currentLat != null && currentLon != null) {
      final vessel = toCanvas(currentLat!, currentLon!);
      canvas.drawCircle(
        vessel,
        6,
        Paint()..color = vesselColor,
      );
      canvas.drawCircle(
        vessel,
        6,
        Paint()
          ..color = anchorColor.withValues(alpha: 0.9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  void _drawAnchorMark(Canvas canvas, Offset center, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx - 8, center.dy),
      Offset(center.dx + 8, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - 8),
      Offset(center.dx, center.dy + 8),
      paint,
    );
    canvas.drawCircle(
      center,
      4,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  double _maxExtentM() {
    var maxM = radiusM * 1.15;
    for (final p in driftHistory) {
      final o = anchorOffsetMeters(
        anchorLat: anchorLat,
        anchorLon: anchorLon,
        lat: p.lat,
        lon: p.lon,
      );
      final d = math.sqrt(o.eastM * o.eastM + o.northM * o.northM);
      if (d > maxM) maxM = d;
    }
    if (currentLat != null && currentLon != null) {
      final o = anchorOffsetMeters(
        anchorLat: anchorLat,
        anchorLon: anchorLon,
        lat: currentLat!,
        lon: currentLon!,
      );
      final d = math.sqrt(o.eastM * o.eastM + o.northM * o.northM);
      if (d > maxM) maxM = d;
    }
    return math.max(maxM, radiusM);
  }

  @override
  bool shouldRepaint(covariant _AnchorZonePainter oldDelegate) {
    return anchorLat != oldDelegate.anchorLat ||
        anchorLon != oldDelegate.anchorLon ||
        radiusM != oldDelegate.radiusM ||
        currentLat != oldDelegate.currentLat ||
        currentLon != oldDelegate.currentLon ||
        driftHistory != oldDelegate.driftHistory;
  }
}
