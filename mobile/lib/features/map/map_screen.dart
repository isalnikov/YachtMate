import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../core/providers.dart';
import '../../data/repositories/route_repository.dart';
import '../../l10n/app_localizations.dart';
import 'chart_engine_platform.dart';

/// MapLibre chart, GNSS dot, draft route polyline (Фаза 1.1–1.4).
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  static const _initial = CameraPosition(target: LatLng(59.94, 30.32), zoom: 9);

  MapLibreMapController? _controller;
  Line? _routeLine;
  bool _styleLoaded = false;
  bool _locResolved = false;
  bool _locOk = false;

  final List<WaypointDraft> _wps = [];
  String? _routeId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _resolveLocationPermission(),
    );
  }

  Future<void> _resolveLocationPermission() async {
    var p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) {
      p = await Geolocator.requestPermission();
    }
    if (!mounted) return;
    setState(() {
      _locResolved = true;
      _locOk =
          p == LocationPermission.always || p == LocationPermission.whileInUse;
    });
  }

  Future<void> _redrawRouteLine() async {
    final c = _controller;
    if (c == null || !_styleLoaded) return;

    if (_wps.length < 2) {
      final line = _routeLine;
      if (line != null) {
        await c.removeLine(line);
        _routeLine = null;
      }
      return;
    }

    final geom = _wps.map((w) => LatLng(w.lat, w.lon)).toList(growable: false);

    final line = _routeLine;
    if (line == null) {
      _routeLine = await c.addLine(
        LineOptions(geometry: geom, lineColor: '#FF7043', lineWidth: 4),
      );
    } else {
      await c.updateLine(line, LineOptions(geometry: geom));
    }
  }

  Future<void> _onLongPress(LatLng pos) async {
    final repo = ref.read(routeRepositoryProvider);
    final audit = ref.read(auditRepositoryProvider);

    _routeId ??= await repo.createDraftRoute(name: 'Route');

    _wps.add(WaypointDraft(lat: pos.latitude, lon: pos.longitude));
    await repo.replaceWaypoints(_routeId!, _wps);

    await audit.record(
      sessionId: ref.read(sessionIdProvider),
      module: 'M1',
      action: 'route_save',
      contextJson: '{"routeId":"$_routeId","points":${_wps.length}}',
    );

    await _redrawRouteLine();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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

    final showLoc = _locResolved && _locOk;

    return Stack(
      children: [
        MapLibreMap(
          initialCameraPosition: _initial,
          trackCameraPosition: true,
          myLocationEnabled: showLoc,
          onMapCreated: (c) => _controller = c,
          onStyleLoadedCallback: () {
            setState(() => _styleLoaded = true);
            unawaited(_redrawRouteLine());
          },
          onMapLongClick: (screen, coords) {
            unawaited(_onLongPress(coords));
          },
        ),
        if (!_styleLoaded)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black26,
              child: Center(child: Text(l10n.mapLoadingStyle)),
            ),
          ),
      ],
    );
  }
}
