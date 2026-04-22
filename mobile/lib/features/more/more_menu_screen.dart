import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../checklist/checklist_hub_screen.dart';
import '../crew/crew_screen.dart';
import '../distress/sos_screen.dart';
import '../logbook/logbook_screen.dart';
import '../settings/settings_screen.dart';
import '../toolbox/maritime_toolbox_screen.dart';
import '../track/track_screen.dart';
import '../vault/vault_screen.dart';

/// Вкладка «Ещё»: вход в модули Фазы 7.
class MoreMenuScreen extends StatelessWidget {
  const MoreMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    void push(Widget child, String title) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (ctx) => Scaffold(
            appBar: AppBar(title: Text(title)),
            body: child,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.moreMenuHeadline, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: Text(l10n.moreMenuSettings),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => push(const SettingsScreen(), l10n.settingsTitle),
        ),
        ListTile(
          leading: const Icon(Icons.dashboard_customize_outlined),
          title: Text(l10n.moreMenuToolbox),
          subtitle: Text(l10n.moreMenuToolboxSubtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => push(const MaritimeToolboxScreen(), l10n.toolboxTitle),
        ),
        ListTile(
          leading: const Icon(Icons.menu_book_outlined),
          title: Text(l10n.moreMenuLogbook),
          trailing: const Icon(Icons.chevron_right),
          onTap: () =>
              push(const LogbookScreen(compact: true), l10n.logbookTitle),
        ),
        ListTile(
          leading: const Icon(Icons.warning_amber_rounded),
          title: Text(l10n.moreMenuSos),
          subtitle: Text(
            l10n.sosBody,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => push(const SosScreen(), l10n.sosTitle),
        ),
        ListTile(
          leading: const Icon(Icons.timeline),
          title: Text(l10n.moreMenuTrack),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => push(const TrackScreen(), l10n.trackTitle),
        ),
        ListTile(
          leading: const Icon(Icons.checklist_rtl),
          title: Text(l10n.moreMenuChecklists),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => push(const ChecklistHubScreen(), l10n.checklistsTitle),
        ),
        ListTile(
          leading: const Icon(Icons.folder_special_outlined),
          title: Text(l10n.moreMenuVault),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => push(const VaultScreen(), l10n.vaultTitle),
        ),
        ListTile(
          leading: const Icon(Icons.groups_outlined),
          title: Text(l10n.moreMenuCrew),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => push(const CrewScreen(), l10n.crewTitle),
        ),
      ],
    );
  }
}
