import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../core/theme/cw_tokens.dart';
import '../../data/local/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_button.dart';
import '../../widgets/cw_button_sizes.dart';
import '../../widgets/cw_card.dart';
import 'offline_chart_providers.dart';

/// Lists downloaded offline chart regions with delete (step 48).
class OfflineChartManagerScreen extends ConsumerWidget {
  const OfflineChartManagerScreen({super.key});

  static String formatStorageLabel(String path) {
    if (path.startsWith('sqlite:')) return '~12 MB';
    return '—';
  }

  static String formatInstalledDate(int installedAtMs, Locale locale) {
    final dt = DateTime.fromMillisecondsSinceEpoch(installedAtMs);
    return DateFormat.yMMMd(locale.toString()).format(dt);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final regions = ref.watch(chartRegionsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.offlineChartManagerTitle)),
      body: regions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (rows) {
          if (rows.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(CwSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.offlineChartManagerLead,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: CwSpacing.l),
                  Text(
                    l10n.offlineChartManagerEmpty,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(CwSpacing.m),
            itemCount: rows.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: CwSpacing.s),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Text(
                  l10n.offlineChartManagerLead,
                  style: Theme.of(context).textTheme.bodyMedium,
                );
              }
              final row = rows[index - 1];
              return _RegionCard(row: row);
            },
          );
        },
      ),
    );
  }
}

class _RegionCard extends ConsumerWidget {
  const _RegionCard({required this.row});

  final ChartRegionRow row;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final storage = OfflineChartManagerScreen.formatStorageLabel(row.path);
    final installed = OfflineChartManagerScreen.formatInstalledDate(
      row.installedAt,
      locale,
    );

    return CwCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            row.regionId,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: CwSpacing.xs),
          Text(
            l10n.offlineChartManagerInstalled(installed),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            l10n.offlineChartManagerLicense(row.licenseTier),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            l10n.offlineChartManagerStorage(storage),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: CwSpacing.s),
          CwButton(
            label: l10n.offlineChartManagerDelete,
            variant: CwButtonVariant.danger,
            size: CwButtonSize.sm,
            onPressed: () => unawaited(_delete(context, ref)),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    await ref.read(chartRegionRepositoryProvider).delete(row.regionId);
    ref.invalidate(chartRegionsProvider);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.offlineChartManagerDeleted)),
    );
  }
}
