import 'dart:async' show unawaited;
import 'dart:math' show Point;

import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../../domain/routing/route_corridor.dart';

/// Purple route line, optional green corridor fill, and leg labels on the map.
class RouteOverlayLayer extends StatefulWidget {
  const RouteOverlayLayer({
    super.key,
    required this.controller,
    required this.waypoints,
    required this.showCorridor,
    required this.cameraTick,
  });

  final MapLibreMapController controller;
  final List<({double lat, double lon})> waypoints;
  final bool showCorridor;
  final int cameraTick;

  @override
  State<RouteOverlayLayer> createState() => _RouteOverlayLayerState();
}

class _RouteOverlayLayerState extends State<RouteOverlayLayer> {
  Line? _routeLine;
  Fill? _corridorFill;
  List<({String label, Point<double> screen})> _legLabels = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_syncMapAnnotations());
      unawaited(_syncLegLabels());
    });
  }

  @override
  void didUpdateWidget(RouteOverlayLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final geomChanged = !_sameWaypoints(oldWidget.waypoints, widget.waypoints);
    final corridorChanged = oldWidget.showCorridor != widget.showCorridor;
    final cameraChanged = oldWidget.cameraTick != widget.cameraTick;

    if (geomChanged || corridorChanged) {
      unawaited(_syncMapAnnotations());
    }
    if (geomChanged || cameraChanged) {
      unawaited(_syncLegLabels());
    }
  }

  @override
  void dispose() {
    unawaited(_removeAnnotations());
    super.dispose();
  }

  bool _sameWaypoints(
    List<({double lat, double lon})> a,
    List<({double lat, double lon})> b,
  ) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].lat != b[i].lat || a[i].lon != b[i].lon) return false;
    }
    return true;
  }

  Future<void> _removeAnnotations() async {
    final c = widget.controller;
    final line = _routeLine;
    if (line != null) {
      await c.removeLine(line);
      _routeLine = null;
    }
    final fill = _corridorFill;
    if (fill != null) {
      await c.removeFill(fill);
      _corridorFill = null;
    }
  }

  Future<void> _syncMapAnnotations() async {
    final c = widget.controller;
    final wps = widget.waypoints;

    if (wps.length < 2) {
      await _removeAnnotations();
      return;
    }

    final geom = wps.map((w) => LatLng(w.lat, w.lon)).toList(growable: false);

    final line = _routeLine;
    if (line == null) {
      _routeLine = await c.addLine(
        LineOptions(
          geometry: geom,
          lineColor: kRouteLineColorHex,
          lineWidth: 3,
        ),
      );
    } else {
      await c.updateLine(line, LineOptions(geometry: geom));
    }

    if (widget.showCorridor) {
      final ring = computeRouteCorridorRing(polyline: wps);
      final fillGeom = [
        ring.map((p) => LatLng(p.$2, p.$1)).toList(growable: false),
      ];
      final fill = _corridorFill;
      if (fill == null) {
        _corridorFill = await c.addFill(
          FillOptions(
            geometry: fillGeom,
            fillColor: kRouteCorridorFillColorHex,
            fillOpacity: 0.15,
            fillOutlineColor: '#00000000',
          ),
        );
      } else {
        await c.updateFill(
          fill,
          FillOptions(
            geometry: fillGeom,
            fillColor: kRouteCorridorFillColorHex,
            fillOpacity: 0.15,
          ),
        );
      }
    } else {
      final fill = _corridorFill;
      if (fill != null) {
        await c.removeFill(fill);
        _corridorFill = null;
      }
    }
  }

  Future<void> _syncLegLabels() async {
    final wps = widget.waypoints;
    if (!mounted || wps.length < 2) {
      if (mounted) setState(() => _legLabels = const []);
      return;
    }

    final legs = routeLegSegments(wps);
    final labels = <({String label, Point<double> screen})>[];

    for (final leg in legs) {
      final raw = await widget.controller.toScreenLocation(
        LatLng(leg.midLat, leg.midLon),
      );
      labels.add((
        label: formatRouteLegLabel(
          bearingDeg: leg.bearingDeg,
          distanceNm: leg.distanceNm,
        ),
        screen: Point<double>(raw.x.toDouble(), raw.y.toDouble()),
      ));
    }

    if (!mounted) return;
    setState(() => _legLabels = labels);
  }

  @override
  Widget build(BuildContext context) {
    if (_legLabels.isEmpty) return const SizedBox.shrink();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        for (final item in _legLabels)
          Positioned(
            left: item.screen.x - 48,
            top: item.screen.y - 12,
            child: _LegLabelChip(text: item.label),
          ),
      ],
    );
  }
}

class _LegLabelChip extends StatelessWidget {
  const _LegLabelChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
