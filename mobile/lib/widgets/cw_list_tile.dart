import 'package:flutter/material.dart';

import '../core/theme/cw_theme_extensions.dart';
import '../core/theme/cw_tokens.dart';
import '../core/theme/cw_typography.dart';

/// Two-line list row with optional leading and trailing widgets.
class CwListTile extends StatelessWidget {
  const CwListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing = const Icon(Icons.chevron_right),
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final theme = Theme.of(context);

    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leading != null) ...[
          IconTheme(
            data: IconThemeData(color: colors.accentTeal, size: 24),
            child: leading!,
          ),
          const SizedBox(width: CwSpacing.m),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: CwSpacing.xs),
                Text(
                  subtitle!,
                  style: CwTypography.caption(color: colors.textMuted),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: CwSpacing.s),
          IconTheme(
            data: IconThemeData(color: colors.textMuted, size: 24),
            child: trailing!,
          ),
        ],
      ],
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      onTap: onTap,
      child: content,
    );
  }
}
