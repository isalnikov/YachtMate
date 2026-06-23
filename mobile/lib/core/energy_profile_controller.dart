import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/audit_repository.dart';

/// Профиль энергии: интервал точек трека и нагрузка на карту/AIS-демо (Фаза 8).
enum EnergyProfile {
  /// Редкие GPS-фиксации, меньше фоновой работы карты.
  eco,

  /// Текущее поведение по умолчанию (30 с трек).
  passage,

  /// Частые точки трека и более частые обновления карты/AIS-демо.
  sport;

  static EnergyProfile decode(String? raw) => switch (raw) {
    'eco' => EnergyProfile.eco,
    'sport' => EnergyProfile.sport,
    _ => EnergyProfile.passage,
  };

  String get encoded => switch (this) {
    EnergyProfile.eco => 'eco',
    EnergyProfile.passage => 'passage',
    EnergyProfile.sport => 'sport',
  };

  Duration get trackSamplingInterval => switch (this) {
    EnergyProfile.eco => const Duration(seconds: 60),
    EnergyProfile.passage => const Duration(seconds: 30),
    EnergyProfile.sport => const Duration(seconds: 10),
  };

  /// Интервал тика AIS-демо (меньше частота — меньше нагрузка в eco).
  Duration get aisDemoTickInterval => switch (this) {
    EnergyProfile.eco => const Duration(seconds: 5),
    EnergyProfile.passage => const Duration(seconds: 2),
    EnergyProfile.sport => const Duration(seconds: 1),
  };

  /// How often the map wind overlay refetches Open-Meteo grid (step 47).
  Duration get windOverlayRefreshInterval => switch (this) {
    EnergyProfile.eco => const Duration(minutes: 30),
    EnergyProfile.passage => const Duration(minutes: 15),
    EnergyProfile.sport => const Duration(minutes: 5),
  };
}

class EnergyProfileController extends StateNotifier<EnergyProfile> {
  EnergyProfileController(this._prefs, this._audit, this._sessionId)
    : super(EnergyProfile.decode(_prefs.getString(preferenceKey)));

  final SharedPreferences _prefs;
  final AuditRepository _audit;
  final String _sessionId;

  static const preferenceKey = 'energyProfile';

  Future<void> setProfile(EnergyProfile profile) async {
    if (profile == state) return;
    final previous = state.encoded;
    await _prefs.setString(preferenceKey, profile.encoded);
    state = profile;
    await _audit.record(
      sessionId: _sessionId,
      module: 'core',
      action: 'energy_profile_change',
      contextJson: '{"from":"$previous","to":"${profile.encoded}"}',
    );
  }
}
