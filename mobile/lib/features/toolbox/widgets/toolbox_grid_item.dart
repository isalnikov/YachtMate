import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../widgets/cw_badge.dart';
import '../../../widgets/cw_card.dart';

/// Compact toolbox hub tile: icon, label, optional status badge.
class ToolboxGridItem extends StatelessWidget {
  const ToolboxGridItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.badgeLabel,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? badgeLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final labelStyle = Theme.of(context).textTheme.bodySmall;

    return Semantics(
      button: true,
      label: badgeLabel == null ? label : '$label, $badgeLabel',
      child: CwCard(
        onTap: onTap,
        padding: const EdgeInsets.all(CwSpacing.m),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: colors.accentTeal),
                const SizedBox(height: CwSpacing.s),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: labelStyle?.copyWith(color: colors.textPrimary),
                ),
              ],
            ),
            if (badgeLabel != null)
              Positioned(
                top: 0,
                right: 0,
                child: CwBadge(
                  label: badgeLabel!,
                  variant: CwBadgeVariant.info,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
