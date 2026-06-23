import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/audit_repository.dart';

/// Night-watch red UI preference (step-26). High contrast remains a separate toggle.
class ThemeModeController extends StateNotifier<bool> {
  ThemeModeController(this._prefs, this._audit, this._sessionId)
    : super(_prefs.getBool(preferenceKey) ?? false);

  final SharedPreferences _prefs;
  final AuditRepository _audit;
  final String _sessionId;

  static const preferenceKey = 'themeNightRedEnabled';

  Future<void> setNightRedEnabled(bool value) async {
    if (value == state) return;
    await _prefs.setBool(preferenceKey, value);
    state = value;
    await _audit.record(
      sessionId: _sessionId,
      module: 'core',
      action: 'theme_night_red',
      contextJson: '{"enabled":$value}',
    );
  }
}
