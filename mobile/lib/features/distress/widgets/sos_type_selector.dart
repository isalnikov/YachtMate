import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';
import '../../../domain/distress/sos_emergency_type.dart';
import '../../../l10n/app_localizations.dart';

/// Emergency type chips: Medical, Fire, Sinking, Man overboard.
class SosTypeSelector extends StatelessWidget {
  const SosTypeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final SosEmergencyType selected;
  final ValueChanged<SosEmergencyType> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.sosTypeLabel,
          style: theme.textTheme.titleSmall?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: CwSpacing.s),
        Wrap(
          spacing: CwSpacing.xs,
          runSpacing: CwSpacing.xs,
          children: [
            for (final type in SosEmergencyType.values)
              _TypeChip(
                key: Key('sos_type_${type.name}'),
                label: type.label(l10n),
                selected: selected == type,
                onTap: () => onSelected(type),
                colors: colors,
              ),
          ],
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.colors,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final CwColors colors;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? colors.textPrimary : colors.textMuted;
    final bg = selected
        ? colors.danger.withValues(alpha: 0.18)
        : colors.deckBlue.withValues(alpha: 0.5);

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: bg,
        shape: StadiumBorder(
          side: BorderSide(
            color: selected
                ? colors.danger.withValues(alpha: 0.55)
                : colors.textMuted.withValues(alpha: 0.2),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(label, style: CwTypography.caption(color: fg)),
          ),
        ),
      ),
    );
  }
}
