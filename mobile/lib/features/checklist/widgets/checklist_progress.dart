import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';

/// Linear progress for checklist completion (done / total).
class ChecklistProgress extends StatelessWidget {
  const ChecklistProgress({
    super.key,
    required this.done,
    required this.total,
  });

  final int done;
  final int total;

  double get _fraction => total == 0 ? 0 : done / total;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        CwSpacing.m,
        CwSpacing.m,
        CwSpacing.m,
        CwSpacing.s,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                '$done / $total',
                style: CwTypography.caption(color: colors.textMuted),
              ),
              const Spacer(),
              Text(
                '${(_fraction * 100).round()}%',
                style: CwTypography.caption(color: colors.accentTeal),
              ),
            ],
          ),
          const SizedBox(height: CwSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(CwRadius.full),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : _fraction,
              minHeight: 6,
              backgroundColor: colors.accentTeal.withValues(alpha: 0.12),
              color: colors.accentTeal,
            ),
          ),
        ],
      ),
    );
  }
}
