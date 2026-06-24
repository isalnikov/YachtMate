import 'dart:async' show StreamSubscription, Timer, unawaited;
import 'dart:math' show Point;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../core/active_route_id.dart';
import '../../core/accessibility_preferences_controller.dart';
import '../../core/energy_profile_controller.dart';
import '../../core/errors/cw_error_catalog.dart';
import '../../core/feature_flags.dart';
import '../../core/logging/app_logger.dart';
import '../../core/map_layer_preferences_controller.dart';
import '../../core/providers.dart';
import '../../core/theme/cw_theme_mode.dart';
import '../../core/theme/cw_tokens.dart';
import '../../core/ship_routing_preferences.dart';
import '../../core/vessel_prefs.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/route_repository.dart';
import '../../domain/ais/ais_target.dart';
import '../../domain/map/demo_navigation_layers_index.dart';
import '../../domain/routing/navigation_layers_depth_grid.dart';
import '../../features/ais/ais_demo_provider.dart';
import '../../features/ais/ais_targets_provider.dart';
import '../../l10n/app_localizations.dart';
import '../mooring/mooring_detail_sheet.dart';
import '../mooring/mooring_map_navigation.dart';
import '../mooring/mooring_providers.dart';
import '../paywall/paywall_placeholder_sheet.dart';
import '../route/advisory_polyline_notifier.dart';
import '../route/route_corridor_preferences.dart';
import '../track/track_recording_controller.dart';
import 'ais_target_layer.dart';
import 'chart_engine_platform.dart';
import 'chart_style_resolver.dart';
import 'demo_map_layers.dart';
import 'map_layer_kinds.dart';
import 'map_layer_sheet.dart';
import 'map_tile_overlay_controller.dart';
import 'map_long_press_sheet.dart';
import '../../domain/weather/wind_grid.dart';
import '../../domain/weather/wind_grid_refresh.dart';
import 'map_wind_overlay_layer.dart';
import 'map_wind_particles_layer.dart';
import 'mooring_layer.dart';
import 'shallow_highlight_layer.dart';
import 'widgets/map_controls_overlay.dart';
import 'widgets/map_peek_sheet.dart';
import 'widgets/map_status_pill.dart';
import 'widgets/route_overlay_layer.dart';

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
  Line? _advisoryLine;
  Line? _trackLine;
  bool _styleLoaded = false;
  String? _appliedStyleUrl;
  bool _locResolved = false;
  bool _locOk = false;

  final List<WaypointDraft> _wps = [];
  String? _routeId;

  DemoNavigationLayersIndex? _layersIndex;
  bool _demoLayersInstalled = false;
  bool _shallowHighlightInstalled = false;
  bool _aisLayerInstalled = false;
  bool _mooringLayerInstalled = false;
  bool _windLayerInstalled = false;

  Timer? _windRefreshTimer;
  DateTime? _windLastFetch;
  WindGridBundle? _lastWindGrid;
  double? _windFetchLat;
  double? _windFetchLon;

  /// Экран ушёл в фон — при eco профиле временно отключаем тяжёлые демо-слои (Фаза 8).
  bool _pausedBackground = false;

  bool _headingUp = false;
  bool _followGps = false;
  double _mapBearing = 0;
  LatLng _mapCenter = _initial.target;
  int _cameraTick = 0;
  StreamSubscription<CompassEvent>? _compassSub;

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
    _windRefreshTimer?.cancel();
    _stopCompassListen();
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

  CwThemeMode _cwThemeMode() {
    return CwThemeMode.resolve(
      nightRedEnabled: ref.read(themeModeProvider),
      highContrastEnabled: ref.read(accessibilityPreferencesProvider).highContrast,
    );
  }

  String _chartStyleUrl([MapLayerVisibility? overridePrefs]) {
    final chartStyle = overridePrefs?.chartStyle ??
        ref.read(mapLayerPreferencesProvider).chartStyle;
    return chartStyleUrlFor(
      chartStyle: chartStyle,
      themeMode: _cwThemeMode(),
    );
  }

  void _resetStyleDependentLayers() {
    _styleLoaded = false;
    _demoLayersInstalled = false;
    _shallowHighlightInstalled = false;
    _aisLayerInstalled = false;
    _mooringLayerInstalled = false;
    _advisoryLine = null;
    _trackLine = null;
  }

  Future<void> _swapChartStyleIfNeeded(
    String url, {
    bool audit = true,
  }) async {
    final c = _controller;
    if (c == null || _appliedStyleUrl == url) return;

    final firstLoad = _appliedStyleUrl == null;
    _appliedStyleUrl = url;

    if (firstLoad) return;

    if (mounted) setState(_resetStyleDependentLayers);

    await c.setStyle(url);

    if (!audit) return;
    await ref.read(auditRepositoryProvider).record(
          sessionId: ref.read(sessionIdProvider),
          module: 'M1',
          action: 'layer_select',
          contextJson: '{"layerId":"chart_style_url","value":"$url"}',
        );
  }

  MapLayerVisibility _effectiveDemoLayers(MapLayerVisibility prefs) {
    final eco = ref.read(energyProfileProvider) == EnergyProfile.eco;
    if (!_pausedBackground || !eco) return prefs;
    return MapLayerVisibility(
      depthContours: false,
      navigationAids: false,
      mooringPois: prefs.mooringPois,
      overlay: prefs.overlay,
      chartStyle: prefs.chartStyle,
      shallowHighlight: prefs.shallowHighlight,
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

    if (mounted) setState(() {});
  }

  String? _overlayBelowLayerId() {
    if (_demoLayersInstalled) return cwDemoDepthLayerId;
    if (_aisLayerInstalled) return cwAisLayerId;
    if (_mooringLayerInstalled) return cwMooringCircleLayerId;
    return null;
  }

  Future<void> _applyMapTileOverlay(MapOverlayKind kind) async {
    final c = _controller;
    if (c == null || !_styleLoaded) return;
    await applyMapTileOverlay(
      c,
      kind,
      belowLayerId: _overlayBelowLayerId(),
    );
  }

  Future<void> _syncShallowHighlightLayer() async {
    final c = _controller;
    final idx = _layersIndex;
    if (c == null || !_shallowHighlightInstalled || idx == null) return;

    final vis = ref.read(mapLayerPreferencesProvider);
    final draftM = ref.read(vesselPrefsProvider).draftM;
    final clearanceM = ref.read(shipRoutingPreferencesProvider).clearanceM;
    final grid = buildNavigationLayersDepthGrid(idx);

    await updateShallowHighlightLayer(
      c,
      grid: grid,
      needDepthM: draftM + clearanceM,
    );
    await applyShallowHighlightVisibility(c, vis.shallowHighlight);
  }

  List<Color> _windScaleColors() {
    final nightRed = ref.read(themeModeProvider);
    return nightRed ? CwPalette.nightWindScale : CwPalette.windScale;
  }

  Future<void> _syncWindOverlayLayer({bool force = false}) async {
    final c = _controller;
    if (c == null || !_windLayerInstalled) return;

    final vis = ref.read(mapLayerPreferencesProvider);
    await applyWindOverlayVisibility(c, vis.windOverlay);
    if (!vis.windOverlay) return;

    final profile = ref.read(energyProfileProvider);
    final interval = profile.windOverlayRefreshInterval;
    final now = DateTime.now();
    if (!force &&
        _windLastFetch != null &&
        now.difference(_windLastFetch!) < interval) {
      return;
    }

    try {
      final grid = await ref
          .read(weatherRepositoryProvider)
          .loadWindGrid(_mapCenter.latitude, _mapCenter.longitude, profile: profile);
      _windLastFetch = now;
      _lastWindGrid = grid;
      _windFetchLat = _mapCenter.latitude;
      _windFetchLon = _mapCenter.longitude;
      if (!mounted || _controller == null) return;
      await updateWindOverlayLayer(
        c,
        grid: grid,
        windScale: _windScaleColors(),
      );
      if (mounted) setState(() {});
    } catch (_) {}
  }

  void _scheduleWindRefreshTimer() {
    _windRefreshTimer?.cancel();
    final vis = ref.read(mapLayerPreferencesProvider);
    if (!vis.windOverlay) return;
    final interval = ref.read(energyProfileProvider).windOverlayRefreshInterval;
    _windRefreshTimer = Timer.periodic(interval, (_) {
      unawaited(_syncWindOverlayLayer(force: true));
    });
  }

  void _onCameraIdle() {
    final vis = ref.read(mapLayerPreferencesProvider);
    if (!vis.windOverlay || !_windLayerInstalled) return;

    if (_windFetchLat == null || _windFetchLon == null) {
      unawaited(_syncWindOverlayLayer(force: true));
      return;
    }

    if (shouldRefreshWindGrid(
      fromLat: _windFetchLat!,
      fromLon: _windFetchLon!,
      toLat: _mapCenter.latitude,
      toLon: _mapCenter.longitude,
    )) {
      unawaited(_syncWindOverlayLayer(force: true));
    }
  }

  Future<void> _afterStyleLoaded() async {
    _appliedStyleUrl = _chartStyleUrl();
    setState(() => _styleLoaded = true);
    await _syncRouteDraftFromRepo();
    await _redrawAdvisoryLine();

    final c = _controller;
    if (c != null) {
      final overlay = ref.read(mapLayerPreferencesProvider).overlay;
      await applyMapTileOverlay(c, overlay);
    }

    final full = await loadDemoLayersGeoJson();
    if (full != null) {
      _layersIndex = DemoNavigationLayersIndex.fromGeoJson(full);
      if (c != null) {
        final vis = ref.read(mapLayerPreferencesProvider);
        _demoLayersInstalled = await installCwDemoLayers(c, full, vis);
        if (_demoLayersInstalled) {
          await installShallowHighlightLayer(c);
          _shallowHighlightInstalled = true;
          await _syncShallowHighlightLayer();
        }
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
    if (c != null) {
      await installWindOverlayLayer(c);
      _windLayerInstalled = true;
      await _syncWindOverlayLayer(force: true);
      _scheduleWindRefreshTimer();
    }
    if (mounted) setState(() {});
    await _applyPendingCameraTarget();
  }

  Future<void> _applyPendingCameraTarget() async {
    final target = ref.read(mapCameraTargetProvider);
    final c = _controller;
    if (target == null || c == null || !_styleLoaded) return;
    await c.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(target.lat, target.lon),
        target.zoom,
      ),
    );
    ref.read(mapCameraTargetProvider.notifier).clear();
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

  Future<void> _zoomIn() async {
    final c = _controller;
    if (c == null) return;
    await c.animateCamera(CameraUpdate.zoomIn());
  }

  Future<void> _zoomOut() async {
    final c = _controller;
    if (c == null) return;
    await c.animateCamera(CameraUpdate.zoomOut());
  }

  void _toggleCompass() {
    setState(() => _headingUp = !_headingUp);
    unawaited(_syncCompassMode());
  }

  Future<void> _syncCompassMode() async {
    final c = _controller;
    if (c == null) return;

    if (!_headingUp) {
      _stopCompassListen();
      await c.animateCamera(CameraUpdate.bearingTo(0));
      if (_followGps) {
        await c.updateMyLocationTrackingMode(MyLocationTrackingMode.tracking);
      }
      return;
    }

    if (_followGps) {
      _stopCompassListen();
      await c.updateMyLocationTrackingMode(
        MyLocationTrackingMode.trackingCompass,
      );
      return;
    }

    _startCompassListen();
  }

  void _startCompassListen() {
    _compassSub?.cancel();
    final stream = FlutterCompass.events;
    if (stream == null) return;
    _compassSub = stream.listen((event) {
      final heading = event.heading;
      final c = _controller;
      if (heading == null || c == null || !_headingUp || _followGps) return;
      unawaited(
        c.animateCamera(
          CameraUpdate.bearingTo(heading),
          duration: const Duration(milliseconds: 200),
        ),
      );
    });
  }

  void _stopCompassListen() {
    unawaited(_compassSub?.cancel());
    _compassSub = null;
  }

  void _toggleFollowGps() {
    setState(() => _followGps = !_followGps);
    unawaited(_syncFollowGps());
  }

  Future<void> _syncFollowGps() async {
    final c = _controller;
    if (c == null) return;

    if (!_followGps) {
      await c.updateMyLocationTrackingMode(MyLocationTrackingMode.none);
      if (_headingUp) _startCompassListen();
      return;
    }

    _stopCompassListen();
    final mode = _headingUp
        ? MyLocationTrackingMode.trackingCompass
        : MyLocationTrackingMode.tracking;
    await c.updateMyLocationTrackingMode(mode);
  }

  void _onCameraTrackingDismissed() {
    if (!mounted || !_followGps) return;
    setState(() => _followGps = false);
    if (_headingUp) _startCompassListen();
  }

  ({double? depthM, String? navLabel}) _mapPointMeta(LatLng pos) {
    final idx = _layersIndex;
    if (idx == null) return (depthM: null, navLabel: null);
    return (
      depthM: idx.nearestContourDepthM(lat: pos.latitude, lon: pos.longitude),
      navLabel: idx.nearestNavAidLabel(lat: pos.latitude, lon: pos.longitude),
    );
  }

  Future<void> _handleMapLongPress(LatLng pos) async {
    if (!mounted) return;
    final meta = _mapPointMeta(pos);

    await showMapLongPressSheet(
      context: context,
      lat: pos.latitude,
      lon: pos.longitude,
      depthMeters: meta.depthM,
      navAidLabel: meta.navLabel,
      onAddWaypoint: () => unawaited(_persistRouteWaypoint(pos)),
      onNavigateHere: () {
        final c = _controller;
        if (c == null) return;
        unawaited(
          c.animateCamera(CameraUpdate.newLatLng(pos)),
        );
      },
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
      if (c != null && _shallowHighlightInstalled) {
        if (prev?.shallowHighlight != next.shallowHighlight) {
          unawaited(applyShallowHighlightVisibility(c, next.shallowHighlight));
        }
      }
      if (c != null && _mooringLayerInstalled) {
        unawaited(applyMooringPlacesVisibility(c, next.mooringPois));
      }
      if (c != null &&
          _styleLoaded &&
          prev?.overlay != next.overlay) {
        unawaited(_applyMapTileOverlay(next.overlay));
      }
      if (prev?.chartStyle != next.chartStyle) {
        unawaited(_swapChartStyleIfNeeded(_chartStyleUrl(next), audit: false));
      }
      if (c != null && _windLayerInstalled) {
        if (prev?.windOverlay != next.windOverlay) {
          unawaited(_syncWindOverlayLayer(force: true));
          _scheduleWindRefreshTimer();
        }
      }
    });

    ref.listen<bool>(themeModeProvider, (prev, next) {
      if (prev == next) return;
      unawaited(_swapChartStyleIfNeeded(_chartStyleUrl()));
    });

    ref.listen<AccessibilityPreferences>(
      accessibilityPreferencesProvider,
      (prev, next) {
        if (prev?.highContrast == next.highContrast) return;
        unawaited(_swapChartStyleIfNeeded(_chartStyleUrl()));
      },
    );

    ref.listen<EnergyProfile>(energyProfileProvider, (prev, next) {
      final c = _controller;
      if (c != null && _demoLayersInstalled) {
        final prefs = ref.read(mapLayerPreferencesProvider);
        unawaited(applyCwDemoLayerVisibility(c, _effectiveDemoLayers(prefs)));
      }
      if (prev?.windOverlayRefreshInterval != next.windOverlayRefreshInterval) {
        _scheduleWindRefreshTimer();
      }
    });

    ref.listen<VesselProfile>(vesselPrefsProvider, (prev, next) {
      if (prev?.draftM != next.draftM) {
        unawaited(_syncShallowHighlightLayer());
      }
    });

    ref.listen<ShipRoutingParams>(shipRoutingPreferencesProvider, (prev, next) {
      if (prev?.clearanceM != next.clearanceM) {
        unawaited(_syncShallowHighlightLayer());
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

    ref.listen<MapCameraTarget?>(mapCameraTargetProvider, (prev, next) {
      if (next != null) unawaited(_applyPendingCameraTarget());
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
    final chartStyleUrl = chartStyleUrlFor(
      chartStyle: ref.watch(mapLayerPreferencesProvider).chartStyle,
      themeMode: CwThemeMode.resolve(
        nightRedEnabled: ref.watch(themeModeProvider),
        highContrastEnabled:
            ref.watch(accessibilityPreferencesProvider).highContrast,
      ),
    );
    final centerMeta = _mapPointMeta(_mapCenter);
    final showCorridor = ref.watch(routeCorridorVisibleProvider);
    final routePoints = _wps
        .map((w) => (lat: w.lat, lon: w.lon))
        .toList(growable: false);
    final mapVis = ref.watch(mapLayerPreferencesProvider);
    final windParticlesAnimate =
        !MediaQuery.of(context).disableAnimations &&
        ref.watch(energyProfileProvider) != EnergyProfile.eco;

    return Stack(
      children: [
        MapLibreMap(
          styleString: chartStyleUrl,
          initialCameraPosition: _initial,
          trackCameraPosition: true,
          compassEnabled: false,
          myLocationEnabled: showLoc,
          myLocationTrackingMode: _followGps
              ? (_headingUp
                  ? MyLocationTrackingMode.trackingCompass
                  : MyLocationTrackingMode.tracking)
              : MyLocationTrackingMode.none,
          onMapCreated: (c) => _controller = c,
          onStyleLoadedCallback: () => unawaited(_afterStyleLoaded()),
          onMapClick: (screen, _) => unawaited(_handleMapTap(screen)),
          onMapLongClick: (screen, coords) {
            unawaited(_handleMapLongPress(coords));
          },
          onCameraMove: (pos) {
            if (!mounted) return;
            setState(() {
              _mapBearing = pos.bearing;
              _mapCenter = pos.target;
              _cameraTick++;
            });
          },
          onCameraIdle: _onCameraIdle,
          onCameraTrackingDismissed: _onCameraTrackingDismissed,
        ),
        if (!_styleLoaded)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black26,
              child: Center(child: Text(l10n.mapLoadingStyle)),
            ),
          ),
        if (_styleLoaded) ...[
          if (mapVis.windOverlay &&
              mapVis.windParticles &&
              _lastWindGrid != null &&
              _lastWindGrid!.cells.isNotEmpty)
            Positioned.fill(
              child: IgnorePointer(
                child: MapWindParticlesLayer(
                  grid: _lastWindGrid!,
                  color: Theme.of(context).colorScheme.primary,
                  animate: windParticlesAnimate,
                ),
              ),
            ),
          const MapStatusPill(),
          RepaintBoundary(
            child: MapControlsOverlay(
            enabled: true,
            headingUp: _headingUp,
            mapBearing: _mapBearing,
            followGps: _followGps,
            onZoomIn: () => unawaited(_zoomIn()),
            onZoomOut: () => unawaited(_zoomOut()),
            onCompassToggle: _toggleCompass,
            onLayers: () => unawaited(showMapLayerSheet(context)),
            onFollowGpsToggle: showLoc ? _toggleFollowGps : null,
            ),
          ),
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
                  unawaited(ref.read(aisDemoToggleProvider)()),
              child: Icon(
                ref.watch(aisDemoProvider)
                    ? Icons.stop_circle_outlined
                    : Icons.play_circle_outline,
              ),
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
          MapPeekSheet(
            lat: _mapCenter.latitude,
            lon: _mapCenter.longitude,
            depthMeters: centerMeta.depthM,
            navAidLabel: centerMeta.navLabel,
          ),
          if (_controller != null && routePoints.length >= 2)
            RouteOverlayLayer(
              controller: _controller!,
              waypoints: routePoints,
              showCorridor: showCorridor,
              cameraTick: _cameraTick,
            ),
        ],
      ],
    );
  }

  Future<void> _cacheVisibleRegion(BuildContext context) async {
    final allowed = await requirePremiumFeature(
      context,
      ref,
      PremiumFeature.offlineCharts,
    );
    if (!allowed) return;

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
          mapStyleUrl: _chartStyleUrl(),
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
      if (context.mounted) {
        showCwErrorSnackBar(context, CwErrorKind.network);
      }
    }
  }
}
