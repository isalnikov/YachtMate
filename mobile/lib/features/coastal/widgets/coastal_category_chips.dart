import 'package:flutter/material.dart';

import '../../../core/theme/cw_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_chip.dart';
import '../shore_poi_category.dart';

/// Horizontal category filter chips for the coastal guide (`all` + POI types).
class CoastalCategoryChips extends StatelessWidget {
  const CoastalCategoryChips({
    super.key,
    required this.selected,
    required this.categories,
    required this.onSelected,
  });

  /// `null` = all categories; otherwise a category key from GeoJSON.
  final String? selected;
  final List<String> categories;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        CwSpacing.m,
        0,
        CwSpacing.m,
        CwSpacing.s,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: CwSpacing.s),
            child: CwChip(
              key: const Key('coastal_category_all'),
              label: l10n.coastalCategoryAll,
              selected: selected == null,
              onSelected: (_) => onSelected(null),
            ),
          ),
          for (final category in categories) ...[
            Padding(
              padding: const EdgeInsets.only(right: CwSpacing.s),
              child: CwChip(
                key: Key('coastal_category_$category'),
                label: shorePoiCategoryLabel(l10n, category),
                selected: selected == category,
                onSelected: (_) => onSelected(category),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
