import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../../l10n/app_localizations.dart';
import '../../map/chart_engine_platform.dart';
import '../../map/widgets/route_overlay_layer.dart';
import '../advisory_polyline_notifier.dart';
import '../route_corridor_preferences.dart';

/// Compact route preview map for tablet split layout.
class RouteMapPanel extends ConsumerStatefulWidget {
  const RouteMapPanel({super.key, required this.waypoints});

  final List<({double lat, double lon})> waypoints;

  @override
  ConsumerState<RouteMapPanel> createState() => _RouteMapPanelState();
}

class _RouteMapPanelState extends ConsumerState<RouteMapPanel> {
  static const _defaultCamera = CameraPosition(
    target: LatLng(36.65, 29.12),
    zoom: 10,
  );

  MapLibreMapController? _controller;
  Line? _advisoryLine;
  bool _styleLoaded = false;
  int _cameraTick = 0;

  CameraPosition get _initial {
    if (widget.waypoints.isEmpty) return _defaultCamera;
    final first = widget.waypoints.first;
    return CameraPosition(target: LatLng(first.lat, first.lon), zoom: 11);
  }

  @override
  void didUpdateWidget(covariant RouteMapPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_styleLoaded) unawaited(_redrawAdvisoryLine());
  }

  Future<void> _redrawAdvisoryLine() async {
    final c = _controller;
    if (c == null || !_styleLoaded) return;

    final pts = ref.read(advisoryPolylineProvider);
    if (pts == null || pts.length < 2) {
      final line = _advisoryLine;
      if (line != null) {
        await c.removeLine(line);
        _advisoryLine = null;
      }
      return;
    }

    final geom = pts.map((p) => LatLng(p.$1, p.$2)).toList(growable: false);
    final line = _advisoryLine;
    if (line == null) {
      _advisoryLine = await c.addLine(
        LineOptions(geometry: geom, lineColor: '#FFC107', lineWidth: 5),
      );
    } else {
      await c.updateLine(line, LineOptions(geometry: geom));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final showCorridor = ref.watch(routeCorridorVisibleProvider);
    final routePoints = widget.waypoints;

    ref.listen(advisoryPolylineProvider, (prev, next) {
      if (_styleLoaded) unawaited(_redrawAdvisoryLine());
    });

    if (!chartEngineSupported()) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.mapUnavailableOnPlatform,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          MapLibreMap(
            initialCameraPosition: _initial,
            compassEnabled: false,
            myLocationEnabled: false,
            onMapCreated: (c) => _controller = c,
            onStyleLoadedCallback: () {
              _styleLoaded = true;
              unawaited(_redrawAdvisoryLine());
            },
            onCameraIdle: () {
              if (mounted) setState(() => _cameraTick++);
            },
          ),
          if (_controller != null && routePoints.length >= 2)
            RouteOverlayLayer(
              controller: _controller!,
              waypoints: routePoints,
              showCorridor: showCorridor,
              cameraTick: _cameraTick,
            ),
        ],
      ),
    );
  }
}
