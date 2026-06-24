import 'package:shared_preferences/shared_preferences.dart';

/// Premium-gated capabilities (step 52).
enum PremiumFeature {
  aisLive,
  offlineCharts,
  gribImport,
}

/// Freemium flags stored in SharedPreferences.
class FeatureFlags {
  const FeatureFlags({required this.premiumUnlocked});

  final bool premiumUnlocked;

  static const premiumKey = 'featureFlagsPremiumUnlocked';

  static FeatureFlags read(SharedPreferences p) {
    return FeatureFlags(premiumUnlocked: p.getBool(premiumKey) ?? false);
  }

  bool canUse(PremiumFeature feature) {
    if (premiumUnlocked) return true;
    return switch (feature) {
      PremiumFeature.aisLive => false,
      PremiumFeature.offlineCharts => false,
      PremiumFeature.gribImport => false,
    };
  }

  String featureLabelKey(PremiumFeature feature) => switch (feature) {
        PremiumFeature.aisLive => 'ais_live',
        PremiumFeature.offlineCharts => 'offline_charts',
        PremiumFeature.gribImport => 'grib_import',
      };
}
