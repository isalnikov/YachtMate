import '../../l10n/app_localizations.dart';

/// Локализованное имя категории узлов (ключ из JSON).
String knotCategoryTitle(AppLocalizations l10n, String category) {
  switch (category) {
    case 'loops':
      return l10n.knotCategoryLoops;
    case 'bends':
      return l10n.knotCategoryBends;
    case 'hitches':
      return l10n.knotCategoryHitches;
    case 'stoppers':
      return l10n.knotCategoryStoppers;
    case 'emergency':
      return l10n.knotCategoryEmergency;
    default:
      return category;
  }
}
