import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../core/logging/app_logger.dart';
import '../../core/map_layer_preferences_controller.dart';
import '../../core/providers.dart';
import '../../data/repositories/route_repository.dart';
import '../../domain/ais/ais_target.dart';
import '../../domain/map/demo_navigation_layers_index.dart';
import '../../features/ais/ais_demo_provider.dart';
import '../../features/ais/ais_targets_provider.dart';
import '../../l10n/app_localizations.dart';
import 'ais_target_layer.dart';
import 'chart_engine_platform.dart';
import 'demo_map_layers.dart';
import 'map_layer_sheet.dart';
import 'map_long_press_sheet.dart';

/// MapLibre chart, GNSS dot, draft route, слои и AIS demo (Фазы 1–3).
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

  DemoNavigationLayersIndex? _layersIndex;
  bool _demoLayersInstalled = false;
  bool _aisLayerInstalled = false;

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

  Future<void> _persistRouteWaypoint(LatLng pos) async {
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

  Future<void> _afterStyleLoaded() async {
    setState(() => _styleLoaded = true);
    await _redrawRouteLine();

    final full = await loadDemoLayersGeoJson();
    final c = _controller;
    if (full != null) {
      _layersIndex = DemoNavigationLayersIndex.fromGeoJson(full);
      if (c != null) {
        final vis = ref.read(mapLayerPreferencesProvider);
        _demoLayersInstalled = await installCwDemoLayers(c, full, vis);
      }
    }
    if (c != null) {
      await installAisTargetLayer(c);
      _aisLayerInstalled = true;
      await updateAisTargetsLayer(c, ref.read(aisTargetsProvider));
    }
    if (mounted) setState(() {});
  }

  Future<void> _handleMapLongPress(LatLng pos) async {
    if (!mounted) return;
    final idx = _layersIndex;

    double? depthM;
    String? navLabel;
    if (idx != null) {
      depthM = idx.nearestContourDepthM(lat: pos.latitude, lon: pos.longitude);
      navLabel =
          idx.nearestNavAidLabel(lat: pos.latitude, lon: pos.longitude);
    }

    await showMapLongPressSheet(
      context: context,
      lat: pos.latitude,
      lon: pos.longitude,
      depthMeters: depthM,
      navAidLabel: navLabel,
      onAddWaypoint: () => unawaited(_persistRouteWaypoint(pos)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    ref.listen<MapLayerVisibility>(mapLayerPreferencesProvider, (prev, next) {
      final c = _controller;
      if (c != null && _demoLayersInstalled) {
        unawaited(applyCwDemoLayerVisibility(c, next));
      }
    });

    ref.listen<Map<int, AisTarget>>(aisTargetsProvider, (prev, next) {
      final c = _controller;
      if (c != null && _aisLayerInstalled) {
        unawaited(updateAisTargetsLayer(c, next));
      }
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

    final showLoc = _locResolved && _locOk;

    return Stack(
      children: [
        MapLibreMap(
          initialCameraPosition: _initial,
          trackCameraPosition: true,
          myLocationEnabled: showLoc,
          onMapCreated: (c) => _controller = c,
          onStyleLoadedCallback: () => unawaited(_afterStyleLoaded()),
          onMapLongClick: (screen, coords) {
            unawaited(_handleMapLongPress(coords));
          },
        ),
        if (!_styleLoaded)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black26,
              child: Center(child: Text(l10n.mapLoadingStyle)),
            ),
          ),
        if (_styleLoaded) ...[
          Positioned(
            right: 12,
            bottom: 164,
            child: FloatingActionButton.small(
              heroTag: 'ais_demo',
              tooltip: l10n.mapAisDemoTooltip,
              backgroundColor: ref.watch(aisDemoProvider)
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
              onPressed: () =>
                  unawaited(ref.read(aisDemoProvider.notifier).toggle()),
              child: Icon(
                ref.watch(aisDemoProvider)
                    ? Icons.stop_circle_outlined
                    : Icons.play_circle_outline,
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 88,
            child: FloatingActionButton.small(
              heroTag: 'map_layers',
              tooltip: l10n.mapLayersTooltip,
              onPressed: () => unawaited(showMapLayerSheet(context)),
              child: const Icon(Icons.layers_outlined),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: FloatingActionButton.small(
              heroTag: 'offline_region',
              onPressed: () => unawaited(_cacheVisibleRegion(context)),
              child: const Icon(Icons.cloud_download_outlined),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _cacheVisibleRegion(BuildContext context) async {
    final c = _controller;
    final messenger = ScaffoldMessenger.maybeOf(context);
    final l10n = AppLocalizations.of(context)!;
    final log = AppLogger('offline');

    if (c == null) return;

    messenger?.showSnackBar(SnackBar(content: Text(l10n.offlineCacheStart)));

    try {
      final bounds = await c.getVisibleRegion();
      final pack = await downloadOfflineRegion(
        OfflineRegionDefinition(
          bounds: bounds,
          mapStyleUrl: MapLibreStyles.demo,
          minZoom: 0,
          maxZoom: 12,
        ),
      );

      await ref
          .read(chartRegionRepositoryProvider)
          .upsert(
            regionId: 'offline_${pack.id}',
            path: 'sqlite:${pack.id}',
            licenseTier: 'demo',
          );

      await ref
          .read(auditRepositoryProvider)
          .record(
            sessionId: ref.read(sessionIdProvider),
            module: 'M1',
            action: 'chart_region_mount',
            contextJson: '{"offlineId":${pack.id},"minZoom":0,"maxZoom":12}',
          );

      messenger?.hideCurrentSnackBar();
      messenger?.showSnackBar(SnackBar(content: Text(l10n.offlineCacheDone)));
    } catch (e) {
      log.warning('offline_download_failed', {'error': e.toString()});
      messenger?.hideCurrentSnackBar();
      messenger?.showSnackBar(SnackBar(content: Text(l10n.offlineCacheFail)));
    }
  }
}
