import '../../l10n/app_localizations.dart';
import '../../widgets/cw_badge.dart';

CwBadgeVariant knotDifficultyBadgeVariant(String difficulty) {
  return switch (difficulty) {
    'hard' => CwBadgeVariant.danger,
    'medium' => CwBadgeVariant.info,
    _ => CwBadgeVariant.safe,
  };
}

String knotDifficultyLabel(AppLocalizations l10n, String difficulty) {
  return switch (difficulty) {
    'hard' => l10n.knotDifficultyHard,
    'medium' => l10n.knotDifficultyMedium,
    _ => l10n.knotDifficultyEasy,
  };
}
