import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';

/// Нижняя панель: выбор языка интерфейса (Фаза 8 — EN/RU/DE/FR/ES/IT).
Future<void> showAppLanguageSheet(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  if (l10n == null) return;
  final current = ref.read(localeControllerProvider);

  Future<void> pick(Locale locale) async {
    await ref.read(localeControllerProvider.notifier).setLocale(locale);
  }

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      Widget row(String code, String title, Locale locale) {
        return ListTile(
          title: Text(title),
          leading: Text(
            code,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          trailing: current.languageCode == locale.languageCode
              ? const Icon(Icons.check)
              : null,
          onTap: () async {
            await pick(locale);
            if (ctx.mounted) Navigator.pop(ctx);
          },
        );
      }

      return SafeArea(
        child: SingleChildScrollView(
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
              row('EN', l10n.localeEnglish, const Locale('en')),
              row('RU', l10n.localeRussian, const Locale('ru')),
              row('DE', l10n.localeGerman, const Locale('de')),
              row('FR', l10n.localeFrench, const Locale('fr')),
              row('ES', l10n.localeSpanish, const Locale('es')),
              row('IT', l10n.localeItalian, const Locale('it')),
            ],
          ),
        ),
      );
    },
  );
}
