import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../domain/coastal/shore_poi.dart';
import '../../l10n/app_localizations.dart';

final shorePoisProvider = FutureProvider<List<ShorePoi>>((ref) async {
  final raw =
      await rootBundle.loadString('assets/coastal/shore_poi_demo.geojson');
  final root = jsonDecode(raw) as Map<String, dynamic>;
  return ShorePoi.parseGeoJson(root);
});

/// Прибрежные POI (F11 MVP — демо GeoJSON).
class CoastalGuideScreen extends ConsumerWidget {
  const CoastalGuideScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final lang = ref.watch(localeControllerProvider).languageCode;
    final async = ref.watch(shorePoisProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, st) => Center(child: Text(l10n.coastalLoadError)),
      data: (pois) {
        if (pois.isEmpty) {
          return Center(child: Text(l10n.coastalEmpty));
        }
        return ListView.builder(
          itemCount: pois.length,
          itemBuilder: (ctx, i) {
            final p = pois[i];
            return ListTile(
              title: Text(p.titleFor(lang)),
              subtitle: Text(
                p.bodyFor(lang),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(p.category),
            );
          },
        );
      },
    );
  }
}
