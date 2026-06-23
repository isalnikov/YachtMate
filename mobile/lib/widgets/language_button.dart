import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../core/theme/cw_theme_extensions.dart';
import '../core/theme/cw_tokens.dart';
import '../features/settings/language_sheet.dart';
import '../l10n/app_localizations.dart';

/// Language picker styled as an unselected [CwChip] pill (EN/RU/…).
class LanguageButton extends ConsumerWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    final colors = context.cwColors;
    final code = ref.watch(localeControllerProvider).languageCode.toUpperCase();

    return Padding(
      padding: const EdgeInsets.only(right: CwSpacing.s),
      child: Semantics(
        button: true,
        label: l10n.languageSwitchTooltip,
        child: Material(
          color: colors.panelBlue.withValues(alpha: 0.9),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CwRadius.full),
            side: BorderSide(color: colors.accentTeal.withValues(alpha: 0.2)),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => showAppLanguageSheet(context, ref),
            splashColor: colors.textMuted.withValues(alpha: 0.12),
            highlightColor: colors.textMuted.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: CwSpacing.s,
              ),
              child: Text(
                code,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.textMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
