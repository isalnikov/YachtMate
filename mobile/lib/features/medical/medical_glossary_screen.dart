import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../domain/reference/medical_entry.dart';
import '../../l10n/app_localizations.dart';

final medicalEntriesProvider = FutureProvider<List<MedicalEntry>>((ref) async {
  final raw =
      await rootBundle.loadString('assets/reference/medical_glossary_demo.json');
  final root = jsonDecode(raw) as Map<String, dynamic>;
  return parseMedicalCatalogJson(root);
});

/// Медицинский справочник (F13 — не замена скорой помощи).
class MedicalGlossaryScreen extends ConsumerWidget {
  const MedicalGlossaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final lang = ref.watch(localeControllerProvider).languageCode;
    final async = ref.watch(medicalEntriesProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, st) => Center(child: Text(l10n.medicalLoadError)),
      data: (entries) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length + 1,
          itemBuilder: (ctx, i) {
            if (i == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  l10n.medicalDisclaimer,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            }
            final e = entries[i - 1];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.titleFor(lang),
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(e.bodyFor(lang)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
