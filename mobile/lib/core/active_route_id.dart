import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

/// SharedPreferences — текущий черновик маршрута (карта и вкладка «Маршрут»).
const kActiveRouteIdKey = 'active_route_id';

/// Подтягивает из БД последний маршрут, если в prefs ещё не сохранён id.
class ActiveRouteIdNotifier extends StateNotifier<String?> {
  ActiveRouteIdNotifier(this._ref)
    : super(_ref.read(sharedPreferencesProvider).getString(kActiveRouteIdKey));

  final Ref _ref;

  Future<void> hydrate() async {
    if (state != null) return;
    final latest = await _ref.read(routeRepositoryProvider).latestRouteId();
    if (latest != null) {
      await _ref
          .read(sharedPreferencesProvider)
          .setString(kActiveRouteIdKey, latest);
      state = latest;
    }
  }

  Future<void> setActive(String id) async {
    await _ref.read(sharedPreferencesProvider).setString(kActiveRouteIdKey, id);
    state = id;
  }
}

final activeRouteIdProvider =
    StateNotifierProvider<ActiveRouteIdNotifier, String?>(
      (ref) => ActiveRouteIdNotifier(ref),
    );
