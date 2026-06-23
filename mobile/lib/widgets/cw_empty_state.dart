import 'package:flutter/material.dart';

import '../core/theme/cw_theme_extensions.dart';
import '../core/theme/cw_tokens.dart';
import '../core/theme/cw_typography.dart';
import 'cw_button.dart';

/// Placeholder when a list or panel has no data: icon, title, optional CTA.
class CwEmptyState extends StatelessWidget {
  const CwEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.ctaLabel,
    this.onCtaPressed,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? ctaLabel;
  final VoidCallback? onCtaPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;

    return Padding(
      padding: const EdgeInsets.all(CwSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: colors.textMuted),
          const SizedBox(height: CwSpacing.m),
          Text(
            title,
            style: CwTypography.h2(color: colors.textPrimary),
            textAlign: TextAlign.center,
          ),
          if (message != null) ...[
            const SizedBox(height: CwSpacing.s),
            Text(
              message!,
              style: CwTypography.body(color: colors.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
          if (ctaLabel != null && onCtaPressed != null) ...[
            const SizedBox(height: CwSpacing.l),
            CwButton(label: ctaLabel!, onPressed: onCtaPressed),
          ],
        ],
      ),
    );
  }
}
