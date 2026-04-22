import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'mooring_detail_sheet.dart';
import 'mooring_providers.dart';

/// Вкладка «Стоянка»: каталог марин и якорных зон (Фаза 6).
class MooringScreen extends ConsumerWidget {
  const MooringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final asyncPlaces = ref.watch(mooringPlacesProvider);

    return asyncPlaces.when(
      data: (places) {
        if (places.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                l10n.mooringEmptyCatalog,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: places.length + 1,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (ctx, i) {
            if (i == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  l10n.mooringScreenTitle,
                  style: theme.textTheme.headlineSmall,
                ),
              );
            }
            final p = places[i - 1];
            final kind = p.kind == 'marina'
                ? l10n.mooringKindMarina
                : l10n.mooringKindAnchorage;
            return ListTile(
              title: Text(p.name),
              subtitle: Text(
                '$kind · ${p.lat.toStringAsFixed(3)}°, ${p.lon.toStringAsFixed(3)}°',
                style: theme.textTheme.bodySmall,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showMooringDetailSheet(context: context, place: p),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
    );
  }
}
