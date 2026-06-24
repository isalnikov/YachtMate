import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/audit_repository.dart';

/// User toggles for local notifications (step 51).
class NotificationPreferences {
  const NotificationPreferences({
    required this.anchorDriftEnabled,
    required this.weatherWindEnabled,
    required this.windThresholdKn,
  });

  final bool anchorDriftEnabled;
  final bool weatherWindEnabled;
  final double windThresholdKn;

  static const anchorKey = 'notifyAnchorDrift';
  static const weatherKey = 'notifyWeatherWind';
  static const windThresholdKey = 'notifyWindThresholdKn';

  static NotificationPreferences read(SharedPreferences p) {
    return NotificationPreferences(
      anchorDriftEnabled: p.getBool(anchorKey) ?? true,
      weatherWindEnabled: p.getBool(weatherKey) ?? true,
      windThresholdKn: p.getDouble(windThresholdKey) ?? 25,
    );
  }
}

class NotificationPreferencesController
    extends StateNotifier<NotificationPreferences> {
  NotificationPreferencesController(this._prefs, this._audit, this._sessionId)
      : super(NotificationPreferences.read(_prefs));

  final SharedPreferences _prefs;
  final AuditRepository _audit;
  final String _sessionId;

  Future<void> setAnchorDriftEnabled(bool v) async {
    await _prefs.setBool(NotificationPreferences.anchorKey, v);
    state = NotificationPreferences.read(_prefs);
    await _auditToggle('anchor_drift', v);
  }

  Future<void> setWeatherWindEnabled(bool v) async {
    await _prefs.setBool(NotificationPreferences.weatherKey, v);
    state = NotificationPreferences.read(_prefs);
    await _auditToggle('weather_wind', v);
  }

  Future<void> setWindThresholdKn(double v) async {
    await _prefs.setDouble(NotificationPreferences.windThresholdKey, v);
    state = NotificationPreferences.read(_prefs);
  }

  Future<void> _auditToggle(String kind, bool enabled) async {
    await _audit.record(
      sessionId: _sessionId,
      module: 'core',
      action: 'notification_toggle',
      contextJson: '{"kind":"$kind","enabled":$enabled}',
    );
  }
}
