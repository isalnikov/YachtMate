import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../domain/tides/tide_demo_models.dart';
import '../../../domain/tides/tide_week_schedule.dart';

/// Smooth tidal height curve with HW/LW markers (demo data).
class TideCurveChart extends StatelessWidget {
  const TideCurveChart({
    super.key,
    required this.anchorEvents,
    required this.dayLocal,
    required this.locale,
    required this.highLabel,
    required this.lowLabel,
  });

  final List<TideEvent> anchorEvents;
  final DateTime dayLocal;
  final String locale;
  final String highLabel;
  final String lowLabel;

  @override
  Widget build(BuildContext context) {
    final events = chartEventsForDay(anchorEvents, dayLocal);
    if (events.length < 2) {
      return const SizedBox(height: 160);
    }

    final windowStart = DateTime(
      dayLocal.year,
      dayLocal.month,
      dayLocal.day,
    );
    final windowEnd = windowStart.add(const Duration(hours: 24));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: CustomPaint(
        painter: _TideCurvePainter(
          events: events,
          windowStart: windowStart,
          windowEnd: windowEnd,
          curveColor: colorScheme.primary,
          markerHighColor: colorScheme.tertiary,
          markerLowColor: colorScheme.secondary,
          gridColor: theme.dividerColor.withValues(alpha: 0.35),
          labelStyle: theme.textTheme.labelSmall!,
          timeFmt: DateFormat.Hm(locale),
          highLabel: highLabel,
          lowLabel: lowLabel,
        ),
      ),
    );
  }
}

class _TideCurvePainter extends CustomPainter {
  _TideCurvePainter({
    required this.events,
    required this.windowStart,
    required this.windowEnd,
    required this.curveColor,
    required this.markerHighColor,
    required this.markerLowColor,
    required this.gridColor,
    required this.labelStyle,
    required this.timeFmt,
    required this.highLabel,
    required this.lowLabel,
  });

  final List<TideEvent> events;
  final DateTime windowStart;
  final DateTime windowEnd;
  final Color curveColor;
  final Color markerHighColor;
  final Color markerLowColor;
  final Color gridColor;
  final TextStyle labelStyle;
  final DateFormat timeFmt;
  final String highLabel;
  final String lowLabel;

  static const _padLeft = 36.0;
  static const _padRight = 12.0;
  static const _padTop = 12.0;
  static const _padBottom = 28.0;

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTWH(
      _padLeft,
      _padTop,
      size.width - _padLeft - _padRight,
      size.height - _padTop - _padBottom,
    );
    if (plot.width <= 0 || plot.height <= 0) return;

    final samples = _sampleCurve(events, windowStart, windowEnd, 160);
    if (samples.length < 2) return;

    final minH = samples.map((s) => s.heightM).reduce(math.min);
    final maxH = samples.map((s) => s.heightM).reduce(math.max);
    final span = (maxH - minH).clamp(0.4, double.infinity);

    double xFor(DateTime t) {
      final ms = windowEnd.difference(windowStart).inMilliseconds;
      if (ms <= 0) return plot.left;
      final f = t.difference(windowStart).inMilliseconds / ms;
      return plot.left + plot.width * f.clamp(0.0, 1.0);
    }

    double yFor(double h) =>
        plot.bottom - ((h - minH) / span) * plot.height;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = plot.top + plot.height * i / 3;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), gridPaint);
    }

    final axisTp = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );
    for (var i = 0; i <= 3; i++) {
      final h = minH + span * (3 - i) / 3;
      axisTp.text = TextSpan(
        text: h.toStringAsFixed(1),
        style: labelStyle.copyWith(color: gridColor),
      );
      axisTp.layout();
      final y = plot.top + plot.height * i / 3 - axisTp.height / 2;
      axisTp.paint(canvas, Offset(0, y));
    }

    final path = Path();
    for (var i = 0; i < samples.length; i++) {
      final p = Offset(xFor(samples[i].time), yFor(samples[i].heightM));
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(xFor(samples.last.time), plot.bottom)
      ..lineTo(xFor(samples.first.time), plot.bottom)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..color = curveColor.withValues(alpha: 0.12)
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = curveColor
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );

    final markerEvents = events.where((e) {
      final local = e.timeUtc.toLocal();
      return !local.isBefore(windowStart) && local.isBefore(windowEnd);
    });

    for (final e in markerEvents) {
      final local = e.timeUtc.toLocal();
      final x = xFor(local);
      final y = yFor(e.heightM);
      final color = e.isHigh ? markerHighColor : markerLowColor;
      canvas.drawCircle(Offset(x, y), 5, Paint()..color = color);
      canvas.drawCircle(
        Offset(x, y),
        8,
        Paint()
          ..color = color.withValues(alpha: 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      final label =
          '${timeFmt.format(local)}\n${e.isHigh ? highLabel : lowLabel}';
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: labelStyle.copyWith(color: color, height: 1.1),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: 72);

      var dx = x - tp.width / 2;
      dx = dx.clamp(plot.left, plot.right - tp.width);
      final above = e.isHigh;
      final dy = above ? y - tp.height - 10 : y + 10;
      tp.paint(
        canvas,
        Offset(dx, dy.clamp(_padTop, size.height - _padBottom)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TideCurvePainter oldDelegate) {
    return oldDelegate.events != events ||
        oldDelegate.windowStart != windowStart ||
        oldDelegate.curveColor != curveColor;
  }
}

List<({DateTime time, double heightM})> _sampleCurve(
  List<TideEvent> events,
  DateTime windowStart,
  DateTime windowEnd,
  int steps,
) {
  final sorted = [...events]..sort((a, b) => a.timeUtc.compareTo(b.timeUtc));
  if (sorted.length < 2) return const [];

  final out = <({DateTime time, double heightM})>[];
  final totalMs = windowEnd.difference(windowStart).inMilliseconds;
  if (totalMs <= 0) return const [];

  for (var i = 0; i <= steps; i++) {
    final t = windowStart.add(
      Duration(milliseconds: (totalMs * i / steps).round()),
    );
    out.add((time: t, heightM: _heightAt(sorted, t)));
  }
  return out;
}

double _heightAt(List<TideEvent> sorted, DateTime when) {
  if (sorted.isEmpty) return 0;
  if (when.isBefore(sorted.first.timeUtc)) {
    return sorted.first.heightM;
  }
  if (!when.isBefore(sorted.last.timeUtc)) {
    return sorted.last.heightM;
  }

  for (var i = 0; i < sorted.length - 1; i++) {
    final a = sorted[i];
    final b = sorted[i + 1];
    if (!when.isBefore(a.timeUtc) && when.isBefore(b.timeUtc)) {
      final p0 = i > 0 ? sorted[i - 1] : a;
      final p1 = a;
      final p2 = b;
      final p3 = i + 2 < sorted.length ? sorted[i + 2] : b;
      final segMs = b.timeUtc.difference(a.timeUtc).inMilliseconds;
      final t = segMs <= 0
          ? 0.0
          : when.difference(a.timeUtc).inMilliseconds / segMs;
      return _catmullRom(p0.heightM, p1.heightM, p2.heightM, p3.heightM, t);
    }
  }
  return sorted.last.heightM;
}

double _catmullRom(double p0, double p1, double p2, double p3, double t) {
  final t2 = t * t;
  final t3 = t2 * t;
  return 0.5 *
      ((2 * p1) +
          (-p0 + p2) * t +
          (2 * p0 - 5 * p1 + 4 * p2 - p3) * t2 +
          (-p0 + 3 * p1 - 3 * p2 + p3) * t3);
}

@visibleForTesting
double tideHeightAt(List<TideEvent> events, DateTime when) {
  final sorted = [...events]..sort((a, b) => a.timeUtc.compareTo(b.timeUtc));
  return _heightAt(sorted, when);
}

@visibleForTesting
double catmullRomSample(double p0, double p1, double p2, double p3, double t) =>
    _catmullRom(p0, p1, p2, p3, t);
