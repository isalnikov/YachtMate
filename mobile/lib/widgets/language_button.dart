import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/language_sheet.dart';
import '../l10n/app_localizations.dart';

/// Кнопка выбора языка (EN/RU), общая для дисклеймера и shell.
class LanguageButton extends ConsumerWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return IconButton(
      icon: const Icon(Icons.language_outlined),
      tooltip: l10n.languageSwitchTooltip,
      onPressed: () => showAppLanguageSheet(context, ref),
    );
  }
}
