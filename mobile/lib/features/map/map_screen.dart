import 'dart:async' show unawaited;
import 'dart:math' show Point;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../core/active_route_id.dart';
import '../../core/energy_profile_controller.dart';
import '../../core/logging/app_logger.dart';
import '../../core/map_layer_preferences_controller.dart';
import '../../core/providers.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/route_repository.dart';
import '../../domain/ais/ais_target.dart';
import '../../domain/map/demo_navigation_layers_index.dart';
import '../../features/ais/ais_demo_provider.dart';
import '../../features/ais/ais_targets_provider.dart';
import '../../l10n/app_localizations.dart';
import '../mooring/mooring_detail_sheet.dart';
import '../mooring/mooring_providers.dart';
import '../route/advisory_polyline_notifier.dart';
import '../track/track_recording_controller.dart';
import 'ais_target_layer.dart';
import 'chart_engine_platform.dart';
import 'demo_map_layers.dart';
import 'map_layer_sheet.dart';
import 'map_long_press_sheet.dart';
import 'mooring_layer.dart';

/// MapLibre chart, GNSS dot, draft route, слои и AIS demo (Фазы 1–3).
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with WidgetsBindingObserver {
  static const _initial = CameraPosition(
    target: LatLng(36.65, 29.12),
    zoom: 10,
  );

  MapLibreMapController? _controller;
  Line? _routeLine;
  Line? _advisoryLine;
  Line? _trackLine;
  bool _styleLoaded = false;
  bool _locResolved = false;
  bool _locOk = false;

  final List<WaypointDraft> _wps = [];
  String? _routeId;

  DemoNavigationLayersIndex? _layersIndex;
  bool _demoLayersInstalled = false;
  bool _aisLayerInstalled = false;
  bool _mooringLayerInstalled = false;

  /// Экран ушёл в фон — при eco профиле временно отключаем тяжёлые демо-слои (Фаза 8).
  bool _pausedBackground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _resolveLocationPermission(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final bg = state == AppLifecycleState.paused;
    if (_pausedBackground == bg) return;
    setState(() => _pausedBackground = bg);
    final c = _controller;
    if (c == null || !_demoLayersInstalled) return;
    final prefs = ref.read(mapLayerPreferencesProvider);
    unawaited(applyCwDemoLayerVisibility(c, _effectiveDemoLayers(prefs)));
  }

  MapLayerVisibility _effectiveDemoLayers(MapLayerVisibility prefs) {
    final eco = ref.read(energyProfileProvider) == EnergyProfile.eco;
    if (!_pausedBackground || !eco) return prefs;
    return MapLayerVisibility(
      depthContours: false,
      navigationAids: false,
      mooringPois: prefs.mooringPois,
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

  Future<void> _redrawTrackLine(List<TrackPointRow> pts) async {
    final c = _controller;
    if (c == null || !_styleLoaded) return;

    if (pts.length < 2) {
      final line = _trackLine;
      if (line != null) {
        await c.removeLine(line);
        _trackLine = null;
      }
      return;
    }

    final geom = pts.map((p) => LatLng(p.lat, p.lon)).toList(growable: false);

    final line = _trackLine;
    if (line == null) {
      _trackLine = await c.addLine(
        LineOptions(geometry: geom, lineColor: '#00E676', lineWidth: 3),
      );
    } else {
      await c.updateLine(line, LineOptions(geometry: geom));
    }
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

    await ref.read(activeRouteIdProvider.notifier).setActive(_routeId!);

    await _redrawRouteLine();
    if (mounted) setState(() {});
  }

  Future<void> _afterStyleLoaded() async {
    setState(() => _styleLoaded = true);
    await _syncRouteDraftFromRepo();
    await _redrawRouteLine();
    await _redrawAdvisoryLine();

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

    await ref.read(mooringSeedFutureProvider.future);
    if (c != null) {
      await installMooringPlacesLayer(c);
      _mooringLayerInstalled = true;
      final places = await ref.read(mooringRepositoryProvider).allPlaces();
      await updateMooringPlacesLayer(c, places);
      await applyMooringPlacesVisibility(
        c,
        ref.read(mapLayerPreferencesProvider).mooringPois,
      );
    }
    if (mounted) setState(() {});
  }

  Future<void> _handleMapTap(Point<double> screen) async {
    final c = _controller;
    if (c == null || !_mooringLayerInstalled) return;
    try {
      final hits = await c.queryRenderedFeatures(screen, [
        cwMooringCircleLayerId,
      ], null);
      if (!context.mounted) return;
      if (hits.isEmpty) return;
      final top = hits.first;
      if (top is! Map) return;
      final props = top['properties'];
      if (props is! Map) return;
      final id = props['id'];
      if (id is! String) return;
      final place = await ref.read(mooringRepositoryProvider).placeById(id);
      if (!context.mounted) return;
      if (place == null) return;
      await ref
          .read(auditRepositoryProvider)
          .record(
            sessionId: ref.read(sessionIdProvider),
            module: 'M6',
            action: 'mooring_marker_open',
            contextJson: '{"placeId":"$id"}',
          );
      if (!context.mounted) return;
      await showMooringDetailSheet(
        // Post-audit guard above; sheet is modal and does not navigate away.
        // ignore: use_build_context_synchronously
        context: context,
        place: place,
      );
    } catch (_) {}
  }

  Future<void> _syncRouteDraftFromRepo() async {
    await ref.read(activeRouteIdProvider.notifier).hydrate();
    final id = ref.read(activeRouteIdProvider);
    if (id == null || !mounted) return;

    final rows = await ref.read(routeRepositoryProvider).waypointsOrdered(id);
    if (!mounted) return;

    setState(() {
      _routeId = id;
      _wps
        ..clear()
        ..addAll(
          rows.map((r) => WaypointDraft(lat: r.lat, lon: r.lon, name: r.name)),
        );
    });
  }

  Future<void> _handleMapLongPress(LatLng pos) async {
    if (!mounted) return;
    final idx = _layersIndex;

    double? depthM;
    String? navLabel;
    if (idx != null) {
      depthM = idx.nearestContourDepthM(lat: pos.latitude, lon: pos.longitude);
      navLabel = idx.nearestNavAidLabel(lat: pos.latitude, lon: pos.longitude);
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
        unawaited(applyCwDemoLayerVisibility(c, _effectiveDemoLayers(next)));
      }
      if (c != null && _mooringLayerInstalled) {
        unawaited(applyMooringPlacesVisibility(c, next.mooringPois));
      }
    });

    ref.listen<EnergyProfile>(energyProfileProvider, (prev, next) {
      final c = _controller;
      if (c != null && _demoLayersInstalled) {
        final prefs = ref.read(mapLayerPreferencesProvider);
        unawaited(applyCwDemoLayerVisibility(c, _effectiveDemoLayers(prefs)));
      }
    });

    ref.listen<Map<int, AisTarget>>(aisTargetsProvider, (prev, next) {
      final c = _controller;
      if (c != null && _aisLayerInstalled) {
        unawaited(updateAisTargetsLayer(c, next));
      }
    });

    ref.listen(advisoryPolylineProvider, (prev, next) {
      if (_styleLoaded) unawaited(_redrawAdvisoryLine());
    });

    ref.listen<AsyncValue<List<MooringPlaceRow>>>(mooringPlacesProvider, (
      prev,
      next,
    ) {
      next.whenData((places) {
        final c = _controller;
        if (c != null && _mooringLayerInstalled) {
          unawaited(updateMooringPlacesLayer(c, places));
        }
      });
    });

    ref.listen<AsyncValue<List<TrackPointRow>>>(activeTrackPointsProvider, (
      prev,
      next,
    ) {
      next.whenData((pts) => unawaited(_redrawTrackLine(pts)));
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
          onMapClick: (screen, _) => unawaited(_handleMapTap(screen)),
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
