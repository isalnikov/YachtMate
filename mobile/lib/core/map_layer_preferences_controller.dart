import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/audit_repository.dart';

/// Видимость демо-слоёв карты (Фаза 2). Значения по умолчанию — выкл., хранятся в SharedPreferences.
class MapLayerVisibility {
  const MapLayerVisibility({
    required this.depthContours,
    required this.navigationAids,
  });

  final bool depthContours;
  final bool navigationAids;

  @override
  bool operator ==(Object other) =>
      other is MapLayerVisibility &&
      other.depthContours == depthContours &&
      other.navigationAids == navigationAids;

  @override
  int get hashCode => Object.hash(depthContours, navigationAids);
}

class MapLayerPreferencesController extends StateNotifier<MapLayerVisibility> {
  MapLayerPreferencesController(
    this._prefs,
    this._audit,
    this._sessionId,
  ) : super(_initial(_prefs));

  final SharedPreferences _prefs;
  final AuditRepository _audit;
  final String _sessionId;

  static const depthPreferenceKey = 'mapLayerDepthDemo';
  static const navAidsPreferenceKey = 'mapLayerNavAidsDemo';

  static MapLayerVisibility _initial(SharedPreferences prefs) {
    return MapLayerVisibility(
      depthContours: prefs.getBool(depthPreferenceKey) ?? false,
      navigationAids: prefs.getBool(navAidsPreferenceKey) ?? false,
    );
  }

  Future<void> setDepthContoursVisible(bool visible) async {
    if (visible == state.depthContours) return;
    await _prefs.setBool(depthPreferenceKey, visible);
    state = MapLayerVisibility(
      depthContours: visible,
      navigationAids: state.navigationAids,
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
    );
    await _audit.record(
      sessionId: _sessionId,
      module: 'M1',
      action: 'layer_toggle',
      contextJson: '{"layerId":"nav_aids_demo","visible":$visible}',
    );
  }
}
