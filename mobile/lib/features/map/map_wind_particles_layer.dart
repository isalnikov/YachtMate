import 'dart:math' show cos, pi, sin;

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../../domain/weather/wind_grid.dart';

/// One animated particle in normalized screen space (0–1).
class WindParticle {
  WindParticle({
    required this.x,
    required this.y,
    required this.speed,
    required this.directionRad,
  });

  double x;
  double y;
  final double speed;
  final double directionRad;
}

/// Builds particles from [grid] wind cells (step 57).
List<WindParticle> seedWindParticles(WindGridBundle grid, {int count = 48}) {
  if (grid.cells.isEmpty) return [];
  final rng = grid.cells.length;
  final out = <WindParticle>[];
  for (var i = 0; i < count; i++) {
    final c = grid.cells[i % rng];
    final toRad = ((c.windDirectionDeg + 180) % 360) * pi / 180;
    out.add(
      WindParticle(
        x: (i * 0.17 + 0.1) % 1.0,
        y: (i * 0.23 + 0.05) % 1.0,
        speed: 0.0008 + (c.windSpeedKn.clamp(0, 45) / 45) * 0.002,
        directionRad: toRad,
      ),
    );
  }
  return out;
}

void tickWindParticles(List<WindParticle> particles) {
  for (final p in particles) {
    p.x += cos(p.directionRad) * p.speed;
    p.y += sin(p.directionRad) * p.speed;
    if (p.x < 0 || p.x > 1 || p.y < 0 || p.y > 1) {
      p.x = p.x.clamp(0.05, 0.95);
      p.y = p.y.clamp(0.05, 0.95);
    }
  }
}

/// GPU-friendly wind streaks overlay (CustomPaint).
class MapWindParticlesPainter extends CustomPainter {
  MapWindParticlesPainter({
    required this.particles,
    required this.color,
  });

  final List<WindParticle> particles;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    for (final p in particles) {
      final ox = p.x * size.width;
      final oy = p.y * size.height;
      final len = 10 + p.speed * 4000;
      final dx = cos(p.directionRad) * len;
      final dy = sin(p.directionRad) * len;
      canvas.drawLine(Offset(ox, oy), Offset(ox + dx, oy + dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant MapWindParticlesPainter oldDelegate) => true;
}

/// Animated overlay; pauses when [animate] is false (eco / reduce motion).
class MapWindParticlesLayer extends StatefulWidget {
  const MapWindParticlesLayer({
    super.key,
    required this.grid,
    required this.color,
    required this.animate,
  });

  final WindGridBundle grid;
  final Color color;
  final bool animate;

  @override
  State<MapWindParticlesLayer> createState() => _MapWindParticlesLayerState();
}

class _MapWindParticlesLayerState extends State<MapWindParticlesLayer>
    with SingleTickerProviderStateMixin {
  late List<WindParticle> _particles;
  Ticker? _ticker;

  @override
  void initState() {
    super.initState();
    _particles = seedWindParticles(widget.grid);
    _syncTicker();
  }

  @override
  void didUpdateWidget(covariant MapWindParticlesLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.grid != widget.grid) {
      _particles = seedWindParticles(widget.grid);
    }
    if (oldWidget.animate != widget.animate) {
      _syncTicker();
    }
  }

  void _syncTicker() {
    _ticker?.dispose();
    _ticker = null;
    if (!widget.animate) return;
    _ticker = createTicker((_) {
      tickWindParticles(_particles);
      setState(() {});
    })
      ..start();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: MapWindParticlesPainter(
          particles: _particles,
          color: widget.color,
        ),
        size: Size.infinite,
      ),
    );
  }
}
