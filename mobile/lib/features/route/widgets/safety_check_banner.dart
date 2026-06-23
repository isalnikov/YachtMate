import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';
import '../../../l10n/app_localizations.dart';

/// Highlights shallow-water risk along the draft route (demo depth grid).
class SafetyCheckBanner extends StatelessWidget {
  const SafetyCheckBanner({
    super.key,
    required this.isUnsafe,
    this.unsafeWaypointIndex,
  });

  final bool isUnsafe;
  final int? unsafeWaypointIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final bg = isUnsafe
        ? colors.danger.withValues(alpha: 0.18)
        : colors.safe.withValues(alpha: 0.14);
    final border = isUnsafe ? colors.danger : colors.safe;
    final icon = isUnsafe ? Icons.warning_amber_rounded : Icons.check_circle_outline;
    final message = isUnsafe
        ? l10n.routeSafetyShallow(unsafeWaypointIndex ?? 0)
        : l10n.routeSafetyOk;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(CwSpacing.m),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(CwRadius.md),
        border: Border.all(color: border.withValues(alpha: 0.65)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: border, size: 22),
          const SizedBox(width: CwSpacing.s),
          Expanded(
            child: Text(
              message,
              style: CwTypography.body(color: colors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
