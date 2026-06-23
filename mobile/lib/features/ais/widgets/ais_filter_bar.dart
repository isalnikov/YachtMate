import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/cw_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../ais_filter_provider.dart';

/// Horizontal chips: Cargo / Tanker / Pleasure / All.
class AisFilterBar extends ConsumerWidget {
  const AisFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selected = ref.watch(aisFilterProvider);
    final theme = Theme.of(context);

    final options = <(AisFilterSelection, String)>[
      (AisFilterSelection.all, l10n.aisFilterAll),
      (AisFilterSelection.cargo, l10n.aisFilterCargo),
      (AisFilterSelection.tanker, l10n.aisFilterTanker),
      (AisFilterSelection.pleasure, l10n.aisFilterPleasure),
    ];

    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0.92),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: CwSpacing.s,
          vertical: CwSpacing.s,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final (value, label) in options) ...[
                Padding(
                  padding: const EdgeInsets.only(right: CwSpacing.s),
                  child: FilterChip(
                    label: Text(label),
                    selected: selected == value,
                    onSelected: (_) =>
                        ref.read(aisFilterProvider.notifier).state = value,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
