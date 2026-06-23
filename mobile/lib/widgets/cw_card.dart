import 'package:flutter/material.dart';

import '../core/theme/cw_theme_extensions.dart';
import '../core/theme/cw_tokens.dart';

/// Panel container: elevation 0, teal border, md radius, m padding.
class CwCard extends StatelessWidget {
  const CwCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final border = BorderSide(
      color: colors.accentTeal.withValues(alpha: 0.12),
    );

    final content = Padding(
      padding: padding ?? const EdgeInsets.all(CwSpacing.m),
      child: child,
    );

    final card = Material(
      color: colors.panelBlue,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CwRadius.md),
        side: border,
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              splashColor: colors.accentTeal.withValues(alpha: 0.12),
              highlightColor: colors.accentTeal.withValues(alpha: 0.08),
              child: content,
            )
          : content,
    );

    if (margin != null) {
      return Padding(padding: margin!, child: card);
    }
    return card;
  }
}
