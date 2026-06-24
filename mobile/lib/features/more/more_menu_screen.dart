import 'package:flutter/material.dart';

import '../../core/theme/cw_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_app_bar.dart';
import '../../widgets/cw_card.dart';
import '../../widgets/cw_list_tile.dart';
import '../ais/ais_screen.dart';
import '../checklist/checklist_hub_screen.dart';
import '../crew/crew_screen.dart';
import '../assistant/assistant_screen.dart';
import '../community/community_hub_screen.dart';
import '../distress/sos_screen.dart';
import '../logbook/logbook_screen.dart';
import '../settings/settings_screen.dart';
import '../tides/tides_screen.dart';
import '../toolbox/maritime_toolbox_screen.dart';
import '../track/track_screen.dart';
import '../vault/vault_screen.dart';
import '../voyage/voyage_monitor_screen.dart';
import '../yacht/yacht_hub_screen.dart';

/// Вкладка «Ещё»: вход в модули Фазы 7.
class MoreMenuScreen extends StatelessWidget {
  const MoreMenuScreen({super.key});

  static const _cardMargin = EdgeInsets.only(bottom: 12);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    void push(Widget child, String title, {bool cwAppBar = false}) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (ctx) => Scaffold(
            appBar: cwAppBar ? CwAppBar(title: title) : AppBar(title: Text(title)),
            body: child,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(CwSpacing.m),
      children: [
        Text(l10n.moreMenuHeadline, style: theme.textTheme.headlineSmall),
        const SizedBox(height: CwSpacing.m),
        CwCard(
          margin: _cardMargin,
          onTap: () => push(
            const CommunityHubScreen(),
            l10n.communityHubTitle,
            cwAppBar: true,
          ),
          child: CwListTile(
            leading: const Icon(Icons.people_outline),
            title: l10n.moreMenuCommunity,
            subtitle: l10n.moreMenuCommunitySubtitle,
          ),
        ),
        CwCard(
          margin: _cardMargin,
          onTap: () => push(
            const YachtHubScreen(),
            l10n.yachtHubTitle,
            cwAppBar: true,
          ),
          child: CwListTile(
            leading: const Icon(Icons.sailing_outlined),
            title: l10n.moreMenuYachtHub,
            subtitle: l10n.moreMenuYachtHubSubtitle,
          ),
        ),
        CwCard(
          margin: _cardMargin,
          onTap: () => push(
            const VoyageMonitorScreen(),
            l10n.voyageMonitorTitle,
            cwAppBar: true,
          ),
          child: CwListTile(
            leading: const Icon(Icons.share_location_outlined),
            title: l10n.moreMenuVoyageMonitor,
            subtitle: l10n.moreMenuVoyageMonitorSubtitle,
          ),
        ),
        CwCard(
          margin: _cardMargin,
          onTap: () => push(
            const AssistantScreen(),
            l10n.assistantTitle,
            cwAppBar: true,
          ),
          child: CwListTile(
            leading: const Icon(Icons.chat_bubble_outline),
            title: l10n.moreMenuAssistant,
            subtitle: l10n.moreMenuAssistantSubtitle,
          ),
        ),
        CwCard(
          margin: _cardMargin,
          onTap: () => push(
            const AisScreen(),
            l10n.aisScreenTitle,
            cwAppBar: true,
          ),
          child: CwListTile(
            leading: const Icon(Icons.radar_outlined),
            title: l10n.moreMenuAis,
            subtitle: l10n.moreMenuAisSubtitle,
          ),
        ),
        CwCard(
          margin: _cardMargin,
          onTap: () => push(const SettingsScreen(), l10n.settingsTitle, cwAppBar: true),
          child: CwListTile(
            leading: const Icon(Icons.settings_outlined),
            title: l10n.moreMenuSettings,
          ),
        ),
        CwCard(
          margin: _cardMargin,
          onTap: () =>
              push(const MaritimeToolboxScreen(), l10n.toolboxTitle, cwAppBar: true),
          child: CwListTile(
            leading: const Icon(Icons.dashboard_customize_outlined),
            title: l10n.moreMenuToolbox,
            subtitle: l10n.moreMenuToolboxSubtitle,
          ),
        ),
        CwCard(
          margin: _cardMargin,
          onTap: () => push(
            const LogbookScreen(compact: true),
            l10n.logbookTitle,
            cwAppBar: true,
          ),
          child: CwListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: l10n.moreMenuLogbook,
          ),
        ),
        CwCard(
          margin: _cardMargin,
          onTap: () => push(const SosScreen(), l10n.sosTitle),
          child: CwListTile(
            leading: const Icon(Icons.warning_amber_rounded),
            title: l10n.moreMenuSos,
            subtitle: l10n.sosBody,
          ),
        ),
        CwCard(
          margin: _cardMargin,
          onTap: () => push(const TidesScreen(), l10n.tidesScreenTitle),
          child: CwListTile(
            leading: const Icon(Icons.waves_outlined),
            title: l10n.moreMenuTides,
            subtitle: l10n.moreMenuTidesSubtitle,
          ),
        ),
        CwCard(
          margin: _cardMargin,
          onTap: () => push(const TrackScreen(), l10n.trackTitle),
          child: CwListTile(
            leading: const Icon(Icons.timeline),
            title: l10n.moreMenuTrack,
          ),
        ),
        CwCard(
          margin: _cardMargin,
          onTap: () => push(const ChecklistHubScreen(), l10n.checklistsTitle),
          child: CwListTile(
            leading: const Icon(Icons.checklist_rtl),
            title: l10n.moreMenuChecklists,
          ),
        ),
        CwCard(
          margin: _cardMargin,
          onTap: () => push(const VaultScreen(), l10n.vaultTitle),
          child: CwListTile(
            leading: const Icon(Icons.folder_special_outlined),
            title: l10n.moreMenuVault,
          ),
        ),
        CwCard(
          onTap: () => push(const CrewScreen(), l10n.crewTitle),
          child: CwListTile(
            leading: const Icon(Icons.groups_outlined),
            title: l10n.moreMenuCrew,
          ),
        ),
      ],
    );
  }
}
