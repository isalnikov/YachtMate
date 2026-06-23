import 'package:flutter/material.dart';

import '../../../core/theme/cw_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_chip.dart';
import '../mooring_list_helpers.dart';

/// Horizontal filter chips (kind) and sort toggles for the mooring catalog.
class MooringFilterBar extends StatelessWidget {
  const MooringFilterBar({
    super.key,
    required this.selectedKinds,
    required this.onKindToggled,
    required this.sortMode,
    required this.onSortChanged,
  });

  final Set<String> selectedKinds;
  final ValueChanged<String> onKindToggled;
  final MooringSortMode sortMode;
  final ValueChanged<MooringSortMode> onSortChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              CwChip(
                label: l10n.mooringKindMarina,
                selected: selectedKinds.contains(kMooringKindMarina),
                onSelected: (_) => onKindToggled(kMooringKindMarina),
              ),
              const SizedBox(width: CwSpacing.xs),
              CwChip(
                label: l10n.mooringKindAnchorage,
                selected: selectedKinds.contains(kMooringKindAnchorage),
                onSelected: (_) => onKindToggled(kMooringKindAnchorage),
              ),
              const SizedBox(width: CwSpacing.xs),
              CwChip(
                label: l10n.mooringKindBuoy,
                selected: selectedKinds.contains(kMooringKindBuoy),
                onSelected: (_) => onKindToggled(kMooringKindBuoy),
              ),
            ],
          ),
        ),
        const SizedBox(height: CwSpacing.s),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              CwChip(
                label: l10n.mooringSortDistance,
                selected: sortMode == MooringSortMode.distance,
                onSelected: (selected) {
                  if (selected) onSortChanged(MooringSortMode.distance);
                },
              ),
              const SizedBox(width: CwSpacing.xs),
              CwChip(
                label: l10n.mooringSortRating,
                selected: sortMode == MooringSortMode.rating,
                onSelected: (selected) {
                  if (selected) onSortChanged(MooringSortMode.rating);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
