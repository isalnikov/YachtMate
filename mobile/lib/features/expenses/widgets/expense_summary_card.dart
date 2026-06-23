import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_card.dart';
import '../expense_categories.dart';

/// Trip total and per-category breakdown for the voyager cashbook.
class ExpenseSummaryCard extends StatelessWidget {
  const ExpenseSummaryCard({
    super.key,
    required this.totalsByCategory,
    this.currency = 'EUR',
  });

  final Map<String, int> totalsByCategory;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final grandTotal =
        totalsByCategory.values.fold<int>(0, (sum, v) => sum + v);
    final categories = kExpenseCategories
        .where((c) => (totalsByCategory[c] ?? 0) > 0)
        .toList(growable: false);

    return CwCard(
      margin: const EdgeInsets.fromLTRB(
        CwSpacing.m,
        CwSpacing.m,
        CwSpacing.m,
        CwSpacing.s,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.expenseSummaryTitle,
            style: CwTypography.h2(color: colors.textPrimary),
          ),
          const SizedBox(height: CwSpacing.m),
          Text(
            formatExpenseAmount(grandTotal, currency),
            style: CwTypography.monoCoords(color: colors.accentTeal).copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (categories.isNotEmpty) ...[
            const SizedBox(height: CwSpacing.m),
            Wrap(
              spacing: CwSpacing.s,
              runSpacing: CwSpacing.s,
              children: [
                for (final category in categories)
                  _CategoryTotalChip(
                    label: expenseCategoryLabel(l10n, category),
                    amount: formatExpenseAmount(
                      totalsByCategory[category]!,
                      currency,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryTotalChip extends StatelessWidget {
  const _CategoryTotalChip({
    required this.label,
    required this.amount,
  });

  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.deckBlue.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(CwRadius.full),
        border: Border.all(color: colors.accentTeal.withValues(alpha: 0.2)),
      ),
      child: Text(
        '$label · $amount',
        style: CwTypography.caption(color: colors.textMuted),
      ),
    );
  }
}
