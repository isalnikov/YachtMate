import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers.dart';

/// Осадка и запас под килем для проверки глубины по сетке (демо Фаза 5).
class ShipRoutingParams {
  const ShipRoutingParams({required this.draftM, required this.clearanceM});

  final double draftM;
  final double clearanceM;

  ShipRoutingParams copyWith({double? draftM, double? clearanceM}) {
    return ShipRoutingParams(
      draftM: draftM ?? this.draftM,
      clearanceM: clearanceM ?? this.clearanceM,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ShipRoutingParams &&
      other.draftM == draftM &&
      other.clearanceM == clearanceM;

  @override
  int get hashCode => Object.hash(draftM, clearanceM);
}

class ShipRoutingPreferencesNotifier extends StateNotifier<ShipRoutingParams> {
  ShipRoutingPreferencesNotifier(this._ref)
    : super(_initial(_ref.read(sharedPreferencesProvider)));

  final Ref _ref;

  static const _draftKey = 'ship_draft_m';
  static const _clearanceKey = 'ship_clearance_m';

  static ShipRoutingParams _initial(SharedPreferences prefs) {
    return ShipRoutingParams(
      draftM: prefs.getDouble(_draftKey) ?? 2.5,
      clearanceM: prefs.getDouble(_clearanceKey) ?? 1.0,
    );
  }

  Future<void> setDraftM(double v) async {
    if (v <= 0 || v == state.draftM) return;
    await _ref.read(sharedPreferencesProvider).setDouble(_draftKey, v);
    state = state.copyWith(draftM: v);
  }

  Future<void> setClearanceM(double v) async {
    if (v < 0 || v == state.clearanceM) return;
    await _ref.read(sharedPreferencesProvider).setDouble(_clearanceKey, v);
    state = state.copyWith(clearanceM: v);
  }
}

final shipRoutingPreferencesProvider =
    StateNotifierProvider<ShipRoutingPreferencesNotifier, ShipRoutingParams>(
      (ref) => ShipRoutingPreferencesNotifier(ref),
    );
