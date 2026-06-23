import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

/// SharedPreferences keys — first-run onboarding (Step 08).
const kOnboardingCompleteKey = 'onboarding_complete';
const kOnboardingExperienceKey = 'onboarding_experience';
const kOnboardingRegionKey = 'onboarding_region';

/// Persists onboarding completion and optional profile picks.
class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier(this._ref)
      : super(
          _ref.read(sharedPreferencesProvider).getBool(kOnboardingCompleteKey) ??
              false,
        );

  final Ref _ref;

  Future<void> complete({
    String? experience,
    String? region,
  }) async {
    final prefs = _ref.read(sharedPreferencesProvider);
    try {
      await prefs.setBool(kOnboardingCompleteKey, true);
      if (experience != null) {
        await prefs.setString(kOnboardingExperienceKey, experience);
      }
      if (region != null) {
        await prefs.setString(kOnboardingRegionKey, region);
      }
    } catch (e, st) {
      debugPrint('Onboarding prefs persist failed: $e\n$st');
    }
    state = true;
  }
}

final onboardingCompleteProvider =
    StateNotifierProvider<OnboardingNotifier, bool>(
  (ref) => OnboardingNotifier(ref),
);
