import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

const kAdvisoryDisclaimerV1AcceptedKey = 'advisory_disclaimer_v1_accepted';

/// Отдельное согласие перед расчётом synthetic depth-grid advisory (Фаза 5).
class AdvisoryDisclaimerNotifier extends StateNotifier<bool> {
  AdvisoryDisclaimerNotifier(this._ref)
    : super(
        _ref
                .read(sharedPreferencesProvider)
                .getBool(kAdvisoryDisclaimerV1AcceptedKey) ??
            false,
      );

  final Ref _ref;

  Future<void> accept() async {
    await _ref
        .read(sharedPreferencesProvider)
        .setBool(kAdvisoryDisclaimerV1AcceptedKey, true);
    state = true;
    try {
      await _ref
          .read(auditRepositoryProvider)
          .record(
            sessionId: _ref.read(sessionIdProvider),
            module: 'M1',
            action: 'advisory_disclaimer_accept',
            contextJson: '{"version":1}',
          );
    } catch (_) {}
  }
}

final advisoryDisclaimerAcceptedProvider =
    StateNotifierProvider<AdvisoryDisclaimerNotifier, bool>(
      (ref) => AdvisoryDisclaimerNotifier(ref),
    );
