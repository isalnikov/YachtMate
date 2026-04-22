import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';

Future<void> showMapLayerSheet(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  if (l10n == null) return;

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Consumer(
            builder: (context, ref, _) {
              final vis = ref.watch(mapLayerPreferencesProvider);
              final notifier = ref.read(mapLayerPreferencesProvider.notifier);

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.mapLayersSheetTitle,
                    style: Theme.of(ctx).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: Text(l10n.mapLayerDepthContours),
                    value: vis.depthContours,
                    onChanged: (v) => notifier.setDepthContoursVisible(v),
                  ),
                  SwitchListTile(
                    title: Text(l10n.mapLayerNavAids),
                    value: vis.navigationAids,
                    onChanged: (v) => notifier.setNavigationAidsVisible(v),
                  ),
                  SwitchListTile(
                    title: Text(l10n.mapLayerMooringPois),
                    value: vis.mooringPois,
                    onChanged: (v) => notifier.setMooringPoisVisible(v),
                  ),
                  const Divider(height: 24),
                  Text(
                    l10n.mapDepthLegendTitle,
                    style: Theme.of(ctx).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4FC3F7),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '5 m',
                          style: Theme.of(ctx).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0288D1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '10 m',
                          style: Theme.of(ctx).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFF01579B),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '20 m',
                          style: Theme.of(ctx).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.mapDepthLegendBody,
                    style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                      color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}
