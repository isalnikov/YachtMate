import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers.dart';

/// Настройки SOS: тестовый режим, контакты, региональные номера (Фаза 7.2).
class SosSettings {
  const SosSettings({
    required this.testMode,
    required this.vesselName,
    required this.smsNumber,
    required this.regionRescueNumber,
  });

  final bool testMode;
  final String vesselName;
  final String smsNumber;
  final String regionRescueNumber;

  static const testModeKey = 'sos_test_mode';
  static const vesselNameKey = 'sos_vessel_name';
  static const smsNumberKey = 'sos_sms_number';
  static const regionRescueNumberKey = 'sos_region_rescue_number';

  static SosSettings read(SharedPreferences p) {
    return SosSettings(
      testMode: p.getBool(testModeKey) ?? true,
      vesselName: p.getString(vesselNameKey) ?? '',
      smsNumber: p.getString(smsNumberKey) ?? '',
      regionRescueNumber: p.getString(regionRescueNumberKey) ?? '',
    );
  }
}

class SosSettingsNotifier extends StateNotifier<SosSettings> {
  SosSettingsNotifier(this._prefs) : super(SosSettings.read(_prefs));

  final SharedPreferences _prefs;

  Future<void> setTestMode(bool v) async {
    await _prefs.setBool(SosSettings.testModeKey, v);
    state = SosSettings.read(_prefs);
  }

  Future<void> setVesselName(String v) async {
    await _prefs.setString(SosSettings.vesselNameKey, v.trim());
    state = SosSettings.read(_prefs);
  }

  Future<void> setSmsNumber(String v) async {
    await _prefs.setString(SosSettings.smsNumberKey, v.trim());
    state = SosSettings.read(_prefs);
  }

  Future<void> setRegionRescueNumber(String v) async {
    await _prefs.setString(SosSettings.regionRescueNumberKey, v.trim());
    state = SosSettings.read(_prefs);
  }
}

final sosSettingsProvider =
    StateNotifierProvider<SosSettingsNotifier, SosSettings>(
      (ref) => SosSettingsNotifier(ref.watch(sharedPreferencesProvider)),
    );
