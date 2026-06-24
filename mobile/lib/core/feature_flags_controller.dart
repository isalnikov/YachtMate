import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/audit_repository.dart';
import 'feature_flags.dart';

class FeatureFlagsController extends StateNotifier<FeatureFlags> {
  FeatureFlagsController(this._prefs, this._audit, this._sessionId)
      : super(FeatureFlags.read(_prefs));

  final SharedPreferences _prefs;
  final AuditRepository _audit;
  final String _sessionId;

  Future<void> setPremiumUnlocked(bool v) async {
    await _prefs.setBool(FeatureFlags.premiumKey, v);
    state = FeatureFlags.read(_prefs);
    await _audit.record(
      sessionId: _sessionId,
      module: 'core',
      action: 'feature_flags_premium',
      contextJson: '{"unlocked":$v}',
    );
  }
}
