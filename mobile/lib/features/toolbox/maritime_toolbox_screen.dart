import 'package:flutter/material.dart';

import '../../core/theme/cw_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_app_bar.dart';
import '../../widgets/cw_section_header.dart';
import '../anchor/anchor_watch_screen.dart';
import '../coastal/coastal_guide_screen.dart';
import '../compass/compass_astro_screen.dart';
import '../expenses/voyager_cashbook_screen.dart';
import '../grib/grib_import_screen.dart';
import '../medical/medical_glossary_screen.dart';
import '../reference/knots_hub_screen.dart';
import '../training/vhf_training_screen.dart';
import 'widgets/toolbox_grid_item.dart';

class _ToolboxEntry {
  const _ToolboxEntry({
    required this.id,
    required this.icon,
    required this.label,
    required this.screen,
    required this.screenTitle,
    this.badgeLabel,
  });

  final String id;
  final IconData icon;
  final String label;
  final Widget screen;
  final String screenTitle;
  final String? badgeLabel;
}

/// Единая точка входа в модули F06, F09–F14.
class MaritimeToolboxScreen extends StatelessWidget {
  const MaritimeToolboxScreen({super.key});

  static const _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: CwSpacing.s,
    crossAxisSpacing: CwSpacing.s,
    childAspectRatio: 1.05,
  );

  List<_ToolboxEntry> _entries(AppLocalizations l10n) => [
        _ToolboxEntry(
          id: 'compass',
          icon: Icons.explore_outlined,
          label: l10n.toolboxCompass,
          screen: const CompassAstroScreen(),
          screenTitle: l10n.compassTitle,
        ),
        _ToolboxEntry(
          id: 'grib',
          icon: Icons.air_outlined,
          label: l10n.toolboxGrib,
          screen: const GribImportScreen(),
          screenTitle: l10n.gribTitle,
          badgeLabel: l10n.badgeNew,
        ),
        _ToolboxEntry(
          id: 'coastal',
          icon: Icons.beach_access_outlined,
          label: l10n.toolboxCoastal,
          screen: const CoastalGuideScreen(),
          screenTitle: l10n.coastalGuideTitle,
        ),
        _ToolboxEntry(
          id: 'anchor_watch',
          icon: Icons.anchor_outlined,
          label: l10n.toolboxAnchorWatch,
          screen: const AnchorWatchScreen(),
          screenTitle: l10n.anchorWatchTitle,
        ),
        _ToolboxEntry(
          id: 'vhf',
          icon: Icons.radio_outlined,
          label: l10n.toolboxVhf,
          screen: const VhfTrainingScreen(),
          screenTitle: l10n.vhfTrainingTitle,
        ),
        _ToolboxEntry(
          id: 'medical',
          icon: Icons.medical_services_outlined,
          label: l10n.toolboxMedical,
          screen: const MedicalGlossaryScreen(),
          screenTitle: l10n.medicalGlossaryTitle,
        ),
        _ToolboxEntry(
          id: 'knots',
          icon: Icons.link_outlined,
          label: l10n.moreMenuKnots,
          screen: const KnotsHubScreen(),
          screenTitle: l10n.knotsTitle,
        ),
        _ToolboxEntry(
          id: 'expenses',
          icon: Icons.account_balance_wallet_outlined,
          label: l10n.toolboxExpenses,
          screen: const VoyagerCashbookScreen(),
          screenTitle: l10n.expensesTitle,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entries = _entries(l10n);

    void push(Widget child, String title) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (ctx) => Scaffold(
            appBar: CwAppBar(title: title),
            body: child,
          ),
        ),
      );
    }

    Widget section(String header, List<_ToolboxEntry> items) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CwSectionHeader(label: header),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: _gridDelegate,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final entry = items[index];
              return ToolboxGridItem(
                key: Key('toolbox_${entry.id}'),
                icon: entry.icon,
                label: entry.label,
                badgeLabel: entry.badgeLabel,
                onTap: () => push(entry.screen, entry.screenTitle),
              );
            },
          ),
        ],
      );
    }

    final byId = {for (final e in entries) e.id: e};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(CwSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.toolboxLead, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: CwSpacing.s),
          section(l10n.toolboxSectionNavigation, [
            byId['compass']!,
            byId['grib']!,
            byId['coastal']!,
          ]),
          section(l10n.toolboxSectionSafety, [
            byId['anchor_watch']!,
            byId['vhf']!,
            byId['medical']!,
          ]),
          section(l10n.toolboxSectionReference, [
            byId['knots']!,
            byId['expenses']!,
          ]),
        ],
      ),
    );
  }
}
