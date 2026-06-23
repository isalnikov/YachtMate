import 'package:flutter/material.dart';

import '../../../core/theme/cw_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_chip.dart';
import '../expense_categories.dart';

/// Horizontal category filter chips for the voyager cashbook.
class ExpenseCategoryChips extends StatelessWidget {
  const ExpenseCategoryChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  /// `null` = all categories.
  final String? selected;
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
              key: const Key('expense_category_all'),
              label: l10n.coastalCategoryAll,
              selected: selected == null,
              onSelected: (_) => onSelected(null),
            ),
          ),
          for (final category in kExpenseCategories) ...[
            Padding(
              padding: const EdgeInsets.only(right: CwSpacing.s),
              child: CwChip(
                key: Key('expense_category_$category'),
                label: expenseCategoryLabel(l10n, category),
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
