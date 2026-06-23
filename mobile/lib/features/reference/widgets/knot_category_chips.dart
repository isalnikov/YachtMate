import 'package:flutter/material.dart';

import '../../../core/theme/cw_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_chip.dart';
import '../knot_category_title.dart';

/// Horizontal category filter chips for the knots hub (`all`, categories, favorites).
class KnotCategoryChips extends StatelessWidget {
  const KnotCategoryChips({
    super.key,
    required this.selected,
    required this.categories,
    required this.onSelected,
  });

  /// `null` = all knots; `favorites` = starred only; otherwise a category key.
  final String? selected;
  final List<String> categories;
  final ValueChanged<String?> onSelected;

  static const favoritesKey = 'favorites';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final options = <(String?, String)>[
      (null, l10n.knotCategoryAll),
      (favoritesKey, l10n.knotCategoryFavorites),
      for (final cat in categories)
        (cat, knotCategoryTitle(l10n, cat)),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(CwSpacing.m, 0, CwSpacing.m, CwSpacing.s),
      child: Row(
        children: [
          for (final (value, label) in options) ...[
            Padding(
              padding: const EdgeInsets.only(right: CwSpacing.s),
              child: CwChip(
                label: label,
                selected: selected == value,
                onSelected: (_) => onSelected(value),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
