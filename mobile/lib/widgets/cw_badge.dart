import 'package:flutter/material.dart';

import '../core/theme/cw_theme_extensions.dart';
import '../core/theme/cw_tokens.dart';

enum CwBadgeVariant { danger, safe, info }

/// Compact status pill: danger, safe, or info.
class CwBadge extends StatelessWidget {
  const CwBadge({
    super.key,
    required this.label,
    this.variant = CwBadgeVariant.info,
  });

  final String label;
  final CwBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final palette = _CwBadgePalette.resolve(variant: variant, colors: colors);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(CwRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: CwSpacing.s,
          vertical: CwSpacing.xs,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: palette.foreground,
          ),
        ),
      ),
    );
  }
}

@immutable
class _CwBadgePalette {
  const _CwBadgePalette({
    required this.background,
    required this.foreground,
  });

  final Color background;
  final Color foreground;

  static _CwBadgePalette resolve({
    required CwBadgeVariant variant,
    required CwColors colors,
  }) {
    return switch (variant) {
      CwBadgeVariant.danger => _CwBadgePalette(
          background: colors.danger.withValues(alpha: 0.2),
          foreground: colors.danger,
        ),
      CwBadgeVariant.safe => _CwBadgePalette(
          background: colors.safe.withValues(alpha: 0.2),
          foreground: colors.safe,
        ),
      CwBadgeVariant.info => _CwBadgePalette(
          background: colors.accentOrange.withValues(alpha: 0.2),
          foreground: colors.accentOrange,
        ),
    };
  }
}
