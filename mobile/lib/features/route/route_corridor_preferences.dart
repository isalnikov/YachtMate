import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers.dart';

const kRouteCorridorVisibleKey = 'route_corridor_visible';

class RouteCorridorVisibleNotifier extends StateNotifier<bool> {
  RouteCorridorVisibleNotifier(this._prefs)
    : super(_prefs.getBool(kRouteCorridorVisibleKey) ?? true);

  final SharedPreferences _prefs;

  Future<void> setVisible(bool visible) async {
    if (visible == state) return;
    await _prefs.setBool(kRouteCorridorVisibleKey, visible);
    state = visible;
  }
}

final routeCorridorVisibleProvider =
    StateNotifierProvider<RouteCorridorVisibleNotifier, bool>((ref) {
      return RouteCorridorVisibleNotifier(ref.read(sharedPreferencesProvider));
    });
