import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';
import '../../../data/local/app_database.dart';
import '../../../widgets/cw_badge.dart';
import '../../../widgets/cw_button.dart';
import '../../../widgets/cw_button_sizes.dart';
import '../../../widgets/cw_card.dart';
import '../expense_categories.dart';

CwBadgeVariant expenseCategoryBadgeVariant(String category) {
  return switch (category) {
    'fuel' || 'gear' => CwBadgeVariant.danger,
    'food' || 'provisions' => CwBadgeVariant.safe,
    _ => CwBadgeVariant.info,
  };
}

/// Cashbook list row: category badge, amount, timestamp, optional note.
class ExpenseEntryCard extends StatelessWidget {
  const ExpenseEntryCard({
    super.key,
    required this.entry,
    required this.categoryLabel,
    required this.onDelete,
  });

  final ExpenseEntryRow entry;
  final String categoryLabel;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final when = DateFormat.yMMMd().add_Hm().format(
      DateTime.fromMillisecondsSinceEpoch(entry.t),
    );
    final amount = formatExpenseAmount(entry.amountMinor, entry.currency);
    final note = (entry.note ?? '').trim();

    return CwCard(
      margin: const EdgeInsets.fromLTRB(
        CwSpacing.m,
        0,
        CwSpacing.m,
        CwSpacing.m,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CwBadge(
                label: categoryLabel,
                variant: expenseCategoryBadgeVariant(entry.category),
              ),
              const Spacer(),
              Text(
                when,
                style: CwTypography.caption(color: colors.textMuted),
              ),
              const SizedBox(width: CwSpacing.xs),
              CwIconButton(
                key: Key('expense_delete_${entry.id}'),
                icon: Icons.delete_outline,
                variant: CwButtonVariant.tertiary,
                size: CwButtonSize.sm,
                semanticLabel: 'Delete',
                onPressed: onDelete,
              ),
            ],
          ),
          const SizedBox(height: CwSpacing.s),
          Text(
            amount,
            style: CwTypography.h2(color: colors.textPrimary),
          ),
          if (note.isNotEmpty) ...[
            const SizedBox(height: CwSpacing.xs),
            Text(
              note,
              style: CwTypography.body(color: colors.textMuted),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
