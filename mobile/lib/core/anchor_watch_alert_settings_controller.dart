import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers.dart';

/// Optional SMS alert when anchor watch latches a drift alarm (step 45).
class AnchorWatchAlertSettings {
  const AnchorWatchAlertSettings({
    required this.smsOnDrift,
    required this.smsNumber,
  });

  final bool smsOnDrift;
  final String smsNumber;

  static const smsOnDriftKey = 'anchorWatchSmsOnDrift';
  static const smsNumberKey = 'anchorWatchSmsNumber';
  static const smsTestModeKey = 'anchorWatchSmsTestMode';

  static AnchorWatchAlertSettings read(SharedPreferences p) {
    return AnchorWatchAlertSettings(
      smsOnDrift: p.getBool(smsOnDriftKey) ?? false,
      smsNumber: p.getString(smsNumberKey) ?? '',
    );
  }

  /// True when anchor SMS should be suppressed (test mode defaults on).
  static bool smsSuppressed(SharedPreferences p) =>
      p.getBool(smsTestModeKey) ?? true;
}

class AnchorWatchAlertSettingsNotifier
    extends StateNotifier<AnchorWatchAlertSettings> {
  AnchorWatchAlertSettingsNotifier(this._prefs)
      : super(AnchorWatchAlertSettings.read(_prefs));

  final SharedPreferences _prefs;

  Future<void> setSmsOnDrift(bool v) async {
    await _prefs.setBool(AnchorWatchAlertSettings.smsOnDriftKey, v);
    state = AnchorWatchAlertSettings.read(_prefs);
  }

  Future<void> setSmsNumber(String v) async {
    await _prefs.setString(AnchorWatchAlertSettings.smsNumberKey, v.trim());
    state = AnchorWatchAlertSettings.read(_prefs);
  }
}

final anchorWatchAlertSettingsProvider = StateNotifierProvider<
    AnchorWatchAlertSettingsNotifier, AnchorWatchAlertSettings>(
  (ref) => AnchorWatchAlertSettingsNotifier(
    ref.watch(sharedPreferencesProvider),
  ),
);
