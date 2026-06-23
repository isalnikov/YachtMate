import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_button.dart';
import '../../../widgets/cw_text_field.dart';

enum VaultPinPanelMode { setup, unlock }

/// PIN entry with lock icon, masked dots, and primary action.
class VaultPinPanel extends StatelessWidget {
  const VaultPinPanel({
    super.key,
    required this.mode,
    required this.primaryController,
    this.confirmController,
    required this.onSubmit,
    this.submitLabel,
  });

  final VaultPinPanelMode mode;
  final TextEditingController primaryController;
  final TextEditingController? confirmController;
  final VoidCallback onSubmit;
  final String? submitLabel;

  static final _pinFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(12),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;

    final title = mode == VaultPinPanelMode.setup
        ? l10n.vaultPinSetupTitle
        : l10n.vaultPinUnlockTitle;
    final actionLabel = submitLabel ??
        (mode == VaultPinPanelMode.setup ? l10n.logbookSave : l10n.vaultUnlock);

    return Padding(
      padding: const EdgeInsets.all(CwSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.lock_outline,
            size: 48,
            color: colors.accentTeal,
            semanticLabel: 'Vault locked',
          ),
          const SizedBox(height: CwSpacing.m),
          Text(
            title,
            style: CwTypography.h2(color: colors.textPrimary),
          ),
          const SizedBox(height: CwSpacing.s),
          Text(
            l10n.vaultLockedHint,
            style: CwTypography.body(color: colors.textMuted),
          ),
          const SizedBox(height: CwSpacing.l),
          CwTextField(
            controller: primaryController,
            label: l10n.vaultPinHint,
            obscureText: true,
            keyboardType: TextInputType.number,
            inputFormatters: _pinFormatters,
            prefixIcon: Icons.lock_outline,
            semanticLabel: mode == VaultPinPanelMode.setup
                ? 'Vault PIN create'
                : 'Vault PIN unlock',
          ),
          if (mode == VaultPinPanelMode.setup) ...[
            const SizedBox(height: CwSpacing.m),
            CwTextField(
              controller: confirmController!,
              label: l10n.vaultPinConfirmLabel,
              obscureText: true,
              keyboardType: TextInputType.number,
              inputFormatters: _pinFormatters,
              prefixIcon: Icons.lock_outline,
              semanticLabel: 'Vault PIN confirm',
            ),
          ],
          const SizedBox(height: CwSpacing.l),
          CwButton(label: actionLabel, onPressed: onSubmit),
        ],
      ),
    );
  }
}
