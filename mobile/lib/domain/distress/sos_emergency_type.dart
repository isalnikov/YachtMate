import '../../l10n/app_localizations.dart';

/// Distress category selected before SOS activation.
enum SosEmergencyType {
  medical,
  fire,
  sinking,
  manOverboard,
}

extension SosEmergencyTypeLabels on SosEmergencyType {
  String label(AppLocalizations l10n) {
    return switch (this) {
      SosEmergencyType.medical => l10n.sosTypeMedical,
      SosEmergencyType.fire => l10n.sosTypeFire,
      SosEmergencyType.sinking => l10n.sosTypeSinking,
      SosEmergencyType.manOverboard => l10n.sosTypeManOverboard,
    };
  }
}
