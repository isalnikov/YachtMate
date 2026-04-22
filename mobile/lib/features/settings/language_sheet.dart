import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';

/// Нижняя панель: выбор **English** / **Русский** (два поддерживаемых языка).
Future<void> showAppLanguageSheet(
  BuildContext context,
  WidgetRef ref,
) async {
  final l10n = AppLocalizations.of(context);
  if (l10n == null) return;
  final current = ref.read(localeControllerProvider);
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                l10n.languageLabel,
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
            ),
            ListTile(
              title: Text(l10n.localeEnglish),
              leading: const Text('EN', style: TextStyle(fontWeight: FontWeight.w600)),
              trailing: current.languageCode == 'en' ? const Icon(Icons.check) : null,
              onTap: () async {
                await ref
                    .read(localeControllerProvider.notifier)
                    .setLocale(const Locale('en'));
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: Text(l10n.localeRussian),
              leading: const Text('RU', style: TextStyle(fontWeight: FontWeight.w600)),
              trailing: current.languageCode == 'ru' ? const Icon(Icons.check) : null,
              onTap: () async {
                await ref
                    .read(localeControllerProvider.notifier)
                    .setLocale(const Locale('ru'));
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
          ],
        ),
      );
    },
  );
}
