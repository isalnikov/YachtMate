import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

/// SharedPreferences key — accepted legal disclaimer (Фаза 1.5).
const kDisclaimerV1AcceptedKey = 'disclaimer_v1_accepted';

/// Persists acceptance and writes `disclaimer_accept` audit (Приложение A).
class DisclaimerNotifier extends StateNotifier<bool> {
  DisclaimerNotifier(this._ref)
    : super(
        _ref
                .read(sharedPreferencesProvider)
                .getBool(kDisclaimerV1AcceptedKey) ??
            false,
      );

  final Ref _ref;

  Future<void> accept() async {
    final prefs = _ref.read(sharedPreferencesProvider);
    await prefs.setBool(kDisclaimerV1AcceptedKey, true);
    state = true;

    try {
      await _ref
          .read(auditRepositoryProvider)
          .record(
            sessionId: _ref.read(sessionIdProvider),
            module: 'core',
            action: 'disclaimer_accept',
            contextJson: '{"version":1}',
          );
    } catch (_) {
      // UI must not depend on audit (e.g. Drift/sql.js on web); prefs already persisted.
    }
  }
}

final disclaimerAcceptedProvider =
    StateNotifierProvider<DisclaimerNotifier, bool>(
      (ref) => DisclaimerNotifier(ref),
    );
