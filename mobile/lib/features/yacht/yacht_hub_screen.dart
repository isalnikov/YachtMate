import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/cw_tokens.dart';
import '../../features/expenses/voyager_cashbook_screen.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_card.dart';
import '../../widgets/cw_section_header.dart';
import '../logbook/logbook_providers.dart';
import '../logbook/logbook_screen.dart';
import '../track/track_recording_controller.dart';
import '../vault/vault_screen.dart';
import '../track/track_screen.dart';

/// Aggregates logbook, expenses, track, vault (step 53).
class YachtHubScreen extends ConsumerWidget {
  const YachtHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final logbook = ref.watch(logbookEntriesProvider);
    final expenses = ref.watch(expensesListProvider);
    final trackPts = ref.watch(activeTrackPointsProvider);

    final logCount = logbook.maybeWhen(data: (v) => v.length, orElse: () => 0);
    final expenseTotal = expenses.maybeWhen(
      data: (rows) => rows.fold<double>(0, (s, r) => s + r.amountMinor / 100),
      orElse: () => 0,
    );
    final trackCount = trackPts.maybeWhen(data: (v) => v.length, orElse: () => 0);

    void push(Widget child, String title) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text(title)),
            body: child,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(CwSpacing.m),
      children: [
        Text(l10n.yachtHubLead, style: theme.textTheme.bodyMedium),
        const SizedBox(height: CwSpacing.m),
        CwSectionHeader(label: l10n.yachtHubTitle),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: CwSpacing.s,
          crossAxisSpacing: CwSpacing.s,
          childAspectRatio: 1.2,
          children: [
            _StatCard(
              icon: Icons.menu_book_outlined,
              label: l10n.yachtHubStatLogbook,
              value: '$logCount',
              onTap: () => push(
                const LogbookScreen(compact: true),
                l10n.logbookTitle,
              ),
            ),
            _StatCard(
              icon: Icons.account_balance_wallet_outlined,
              label: l10n.yachtHubStatExpenses,
              value: expenseTotal.toStringAsFixed(0),
              onTap: () => push(
                const VoyagerCashbookScreen(),
                l10n.expensesTitle,
              ),
            ),
            _StatCard(
              icon: Icons.timeline,
              label: l10n.yachtHubStatTrack,
              value: '$trackCount',
              onTap: () => push(const TrackScreen(), l10n.trackTitle),
            ),
            _StatCard(
              icon: Icons.folder_special_outlined,
              label: l10n.yachtHubStatVault,
              value: '→',
              onTap: () => push(const VaultScreen(), l10n.vaultTitle),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CwCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: CwSpacing.s),
          Text(value, style: theme.textTheme.headlineSmall),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
