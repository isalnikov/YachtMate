import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/audit_repository.dart';
import '../features/map/map_layer_kinds.dart';

/// Видимость демо-слоёв карты (Фаза 2). Значения по умолчанию — выкл., хранятся в SharedPreferences.
class MapLayerVisibility {
  const MapLayerVisibility({
    required this.depthContours,
    required this.navigationAids,
    required this.mooringPois,
    this.overlay = MapOverlayKind.none,
    this.chartStyle = ChartStyleKind.standard,
    this.shallowHighlight = false,
    this.windOverlay = false,
    this.windParticles = false,
  });

  final bool depthContours;
  final bool navigationAids;

  /// Марины / якорные (Фаза 6). По умолчанию вкл., чтобы объекты были видны после сида.
  final bool mooringPois;

  final MapOverlayKind overlay;
  final ChartStyleKind chartStyle;
  final bool shallowHighlight;
  final bool windOverlay;
  final bool windParticles;

  @override
  bool operator ==(Object other) =>
      other is MapLayerVisibility &&
      other.depthContours == depthContours &&
      other.navigationAids == navigationAids &&
      other.mooringPois == mooringPois &&
      other.overlay == overlay &&
      other.chartStyle == chartStyle &&
      other.shallowHighlight == shallowHighlight &&
      other.windOverlay == windOverlay &&
      other.windParticles == windParticles;

  @override
  int get hashCode => Object.hash(
    depthContours,
    navigationAids,
    mooringPois,
    overlay,
    chartStyle,
    shallowHighlight,
    windOverlay,
    windParticles,
  );
}

class MapLayerPreferencesController extends StateNotifier<MapLayerVisibility> {
  MapLayerPreferencesController(this._prefs, this._audit, this._sessionId)
    : super(_initial(_prefs));

  final SharedPreferences _prefs;
  final AuditRepository _audit;
  final String _sessionId;

  static const depthPreferenceKey = 'mapLayerDepthDemo';
  static const navAidsPreferenceKey = 'mapLayerNavAidsDemo';
  static const mooringPoisPreferenceKey = 'mapLayerMooringPois';
  static const overlayPreferenceKey = 'mapLayerOverlay';
  static const chartStylePreferenceKey = 'mapLayerChartStyle';
  static const shallowHighlightPreferenceKey = 'mapLayerShallowHighlight';
  static const windOverlayPreferenceKey = 'mapLayerWindOverlay';
  static const windParticlesPreferenceKey = 'mapLayerWindParticles';

  static MapLayerVisibility _initial(SharedPreferences prefs) {
    return MapLayerVisibility(
      depthContours: prefs.getBool(depthPreferenceKey) ?? false,
      navigationAids: prefs.getBool(navAidsPreferenceKey) ?? false,
      mooringPois: prefs.getBool(mooringPoisPreferenceKey) ?? true,
      overlay: MapOverlayKindStorage.fromStorage(
        prefs.getString(overlayPreferenceKey),
      ),
      chartStyle: ChartStyleKindStorage.fromStorage(
        prefs.getString(chartStylePreferenceKey),
      ),
      shallowHighlight: prefs.getBool(shallowHighlightPreferenceKey) ?? false,
      windOverlay: prefs.getBool(windOverlayPreferenceKey) ?? false,
      windParticles: prefs.getBool(windParticlesPreferenceKey) ?? false,
    );
  }

  Future<void> setDepthContoursVisible(bool visible) async {
    if (visible == state.depthContours) return;
    await _prefs.setBool(depthPreferenceKey, visible);
    state = MapLayerVisibility(
      depthContours: visible,
      navigationAids: state.navigationAids,
      mooringPois: state.mooringPois,
      overlay: state.overlay,
      chartStyle: state.chartStyle,
      shallowHighlight: state.shallowHighlight,
      windOverlay: state.windOverlay,
      windParticles: state.windParticles,
    );
    await _audit.record(
      sessionId: _sessionId,
      module: 'M1',
      action: 'layer_toggle',
      contextJson: '{"layerId":"depth_demo","visible":$visible}',
    );
  }

  Future<void> setNavigationAidsVisible(bool visible) async {
    if (visible == state.navigationAids) return;
    await _prefs.setBool(navAidsPreferenceKey, visible);
    state = MapLayerVisibility(
      depthContours: state.depthContours,
      navigationAids: visible,
      mooringPois: state.mooringPois,
      overlay: state.overlay,
      chartStyle: state.chartStyle,
      shallowHighlight: state.shallowHighlight,
      windOverlay: state.windOverlay,
      windParticles: state.windParticles,
    );
    await _audit.record(
      sessionId: _sessionId,
      module: 'M1',
      action: 'layer_toggle',
      contextJson: '{"layerId":"nav_aids_demo","visible":$visible}',
    );
  }

  Future<void> setMooringPoisVisible(bool visible) async {
    if (visible == state.mooringPois) return;
    await _prefs.setBool(mooringPoisPreferenceKey, visible);
    state = MapLayerVisibility(
      depthContours: state.depthContours,
      navigationAids: state.navigationAids,
      mooringPois: visible,
      overlay: state.overlay,
      chartStyle: state.chartStyle,
      shallowHighlight: state.shallowHighlight,
      windOverlay: state.windOverlay,
      windParticles: state.windParticles,
    );
    await _audit.record(
      sessionId: _sessionId,
      module: 'M1',
      action: 'layer_toggle',
      contextJson: '{"layerId":"mooring_pois","visible":$visible}',
    );
  }

  Future<void> setOverlay(MapOverlayKind overlay) async {
    if (overlay == state.overlay) return;
    await _prefs.setString(overlayPreferenceKey, overlay.storageKey);
    state = MapLayerVisibility(
      depthContours: state.depthContours,
      navigationAids: state.navigationAids,
      mooringPois: state.mooringPois,
      overlay: overlay,
      chartStyle: state.chartStyle,
      shallowHighlight: state.shallowHighlight,
      windOverlay: state.windOverlay,
      windParticles: state.windParticles,
    );
    await _audit.record(
      sessionId: _sessionId,
      module: 'M1',
      action: 'layer_select',
      contextJson: '{"layerId":"overlay","value":"${overlay.storageKey}"}',
    );
  }

  Future<void> setChartStyle(ChartStyleKind chartStyle) async {
    if (chartStyle == state.chartStyle) return;
    await _prefs.setString(chartStylePreferenceKey, chartStyle.storageKey);
    state = MapLayerVisibility(
      depthContours: state.depthContours,
      navigationAids: state.navigationAids,
      mooringPois: state.mooringPois,
      overlay: state.overlay,
      chartStyle: chartStyle,
      shallowHighlight: state.shallowHighlight,
      windOverlay: state.windOverlay,
      windParticles: state.windParticles,
    );
    await _audit.record(
      sessionId: _sessionId,
      module: 'M1',
      action: 'layer_select',
      contextJson:
          '{"layerId":"chart_style","value":"${chartStyle.storageKey}"}',
    );
  }

  Future<void> setShallowHighlight(bool enabled) async {
    if (enabled == state.shallowHighlight) return;
    await _prefs.setBool(shallowHighlightPreferenceKey, enabled);
    state = MapLayerVisibility(
      depthContours: state.depthContours,
      navigationAids: state.navigationAids,
      mooringPois: state.mooringPois,
      overlay: state.overlay,
      chartStyle: state.chartStyle,
      shallowHighlight: enabled,
      windOverlay: state.windOverlay,
      windParticles: state.windParticles,
    );
    await _audit.record(
      sessionId: _sessionId,
      module: 'M1',
      action: 'layer_toggle',
      contextJson: '{"layerId":"shallow_highlight","visible":$enabled}',
    );
  }

  Future<void> setWindOverlay(bool enabled) async {
    if (enabled == state.windOverlay) return;
    await _prefs.setBool(windOverlayPreferenceKey, enabled);
    state = MapLayerVisibility(
      depthContours: state.depthContours,
      navigationAids: state.navigationAids,
      mooringPois: state.mooringPois,
      overlay: state.overlay,
      chartStyle: state.chartStyle,
      shallowHighlight: state.shallowHighlight,
      windOverlay: enabled,
      windParticles: state.windParticles,
    );
    await _audit.record(
      sessionId: _sessionId,
      module: 'M1',
      action: 'layer_toggle',
      contextJson: '{"layerId":"wind_overlay","visible":$enabled}',
    );
  }

  Future<void> setWindParticles(bool enabled) async {
    if (enabled == state.windParticles) return;
    await _prefs.setBool(windParticlesPreferenceKey, enabled);
    state = MapLayerVisibility(
      depthContours: state.depthContours,
      navigationAids: state.navigationAids,
      mooringPois: state.mooringPois,
      overlay: state.overlay,
      chartStyle: state.chartStyle,
      shallowHighlight: state.shallowHighlight,
      windOverlay: state.windOverlay,
      windParticles: enabled,
    );
    await _audit.record(
      sessionId: _sessionId,
      module: 'M1',
      action: 'layer_toggle',
      contextJson: '{"layerId":"wind_particles","visible":$enabled}',
    );
  }
}
