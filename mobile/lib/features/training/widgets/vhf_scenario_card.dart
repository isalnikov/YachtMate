import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';
import '../../../domain/training/vhf_scenario.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_card.dart';

/// Selectable VHF practice scenario with difficulty chip.
class VhfScenarioCard extends StatelessWidget {
  const VhfScenarioCard({
    super.key,
    required this.scenario,
    required this.lang,
    required this.onTap,
    this.selected = false,
  });

  final VhfScenario scenario;
  final String lang;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final difficultyLabel = _difficultyLabel(l10n, scenario.difficulty);
    final difficultyColor = _difficultyColor(colors, scenario.difficulty);

    return CwCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: CwSpacing.m),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.radio,
            color: selected ? colors.accentTeal : colors.textMuted,
            size: 28,
          ),
          const SizedBox(width: CwSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scenario.titleFor(lang),
                  style: CwTypography.h2(
                    color: selected ? colors.accentTeal : colors.textPrimary,
                  ),
                ),
                const SizedBox(height: CwSpacing.xs),
                Text(
                  scenario.summaryFor(lang),
                  style: CwTypography.caption(color: colors.textMuted),
                ),
                const SizedBox(height: CwSpacing.s),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: CwSpacing.s,
                    vertical: CwSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: difficultyColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(CwRadius.sm),
                    border: Border.all(
                      color: difficultyColor.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Text(
                    difficultyLabel,
                    style: CwTypography.caption(color: difficultyColor),
                  ),
                ),
              ],
            ),
          ),
          if (selected)
            Icon(Icons.check_circle, color: colors.accentTeal, size: 22),
        ],
      ),
    );
  }

  String _difficultyLabel(AppLocalizations l10n, VhfScenarioDifficulty d) {
    switch (d) {
      case VhfScenarioDifficulty.beginner:
        return l10n.vhfDifficultyBeginner;
      case VhfScenarioDifficulty.intermediate:
        return l10n.vhfDifficultyIntermediate;
      case VhfScenarioDifficulty.advanced:
        return l10n.vhfDifficultyAdvanced;
    }
  }

  Color _difficultyColor(CwColors colors, VhfScenarioDifficulty d) {
    switch (d) {
      case VhfScenarioDifficulty.beginner:
        return colors.safe;
      case VhfScenarioDifficulty.intermediate:
        return colors.accentOrange;
      case VhfScenarioDifficulty.advanced:
        return colors.danger;
    }
  }
}
