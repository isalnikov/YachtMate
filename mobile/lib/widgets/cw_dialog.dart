import 'package:flutter/material.dart';

import '../core/theme/cw_theme_extensions.dart';
import '../core/theme/cw_tokens.dart';
import '../core/theme/cw_typography.dart';
import 'cw_button.dart';

enum CwDialogVariant { confirm, danger }

/// Shows a themed confirm or danger dialog; returns `true` on confirm.
Future<bool?> showCwDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  String? cancelLabel,
  CwDialogVariant variant = CwDialogVariant.confirm,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => CwDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      variant: variant,
    ),
  );
}

/// Themed dialog with confirm and cancel actions.
class CwDialog extends StatelessWidget {
  const CwDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.cancelLabel,
    this.variant = CwDialogVariant.confirm,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String? cancelLabel;
  final CwDialogVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final confirmVariant = variant == CwDialogVariant.danger
        ? CwButtonVariant.danger
        : CwButtonVariant.primary;

    return Dialog(
      backgroundColor: colors.panelBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CwRadius.md),
        side: BorderSide(color: colors.accentTeal.withValues(alpha: 0.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(CwSpacing.m),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: CwTypography.h2(color: colors.textPrimary)),
            const SizedBox(height: CwSpacing.s),
            Text(
              message,
              style: CwTypography.body(color: colors.textMuted),
            ),
            const SizedBox(height: CwSpacing.l),
            if (cancelLabel != null) ...[
              Row(
                children: [
                  Expanded(
                    child: CwButton(
                      label: cancelLabel!,
                      variant: CwButtonVariant.secondary,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: CwSpacing.s),
                  Expanded(
                    child: CwButton(
                      label: confirmLabel,
                      variant: confirmVariant,
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ),
                ],
              ),
            ] else
              CwButton(
                label: confirmLabel,
                variant: confirmVariant,
                onPressed: () => Navigator.of(context).pop(true),
              ),
          ],
        ),
      ),
    );
  }
}
