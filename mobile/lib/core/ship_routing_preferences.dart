import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers.dart';

/// Under-keel clearance for depth grid checks (demonstration phase 5).
class ShipRoutingParams {
  const ShipRoutingParams({required this.clearanceM});

  final double clearanceM;

  ShipRoutingParams copyWith({double? clearanceM}) {
    return ShipRoutingParams(clearanceM: clearanceM ?? this.clearanceM);
  }

  @override
  bool operator ==(Object other) =>
      other is ShipRoutingParams && other.clearanceM == clearanceM;

  @override
  int get hashCode => clearanceM.hashCode;
}

class ShipRoutingPreferencesNotifier extends StateNotifier<ShipRoutingParams> {
  ShipRoutingPreferencesNotifier(this._ref)
    : super(_initial(_ref.read(sharedPreferencesProvider)));

  final Ref _ref;

  static const _clearanceKey = 'ship_clearance_m';

  static ShipRoutingParams _initial(SharedPreferences prefs) {
    return ShipRoutingParams(
      clearanceM: prefs.getDouble(_clearanceKey) ?? 1.0,
    );
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
