import 'package:flutter/material.dart';

import '../core/theme/cw_theme_extensions.dart';
import '../core/theme/cw_tokens.dart';
import '../core/theme/cw_typography.dart';
import 'cw_button.dart';

/// Error placeholder with retry action.
class CwErrorState extends StatelessWidget {
  const CwErrorState({
    super.key,
    required this.title,
    this.message,
    required this.retryLabel,
    this.onRetry,
  });

  final String title;
  final String? message;
  final String retryLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;

    return Padding(
      padding: const EdgeInsets.all(CwSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: colors.danger),
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
          const SizedBox(height: CwSpacing.l),
          CwButton(
            label: retryLabel,
            onPressed: onRetry,
            variant: CwButtonVariant.secondary,
          ),
        ],
      ),
    );
  }
}
