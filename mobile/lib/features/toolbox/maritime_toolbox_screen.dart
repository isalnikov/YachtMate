import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../anchor/anchor_watch_screen.dart';
import '../coastal/coastal_guide_screen.dart';
import '../compass/compass_astro_screen.dart';
import '../expenses/voyager_cashbook_screen.dart';
import '../grib/grib_import_screen.dart';
import '../medical/medical_glossary_screen.dart';
import '../reference/knots_hub_screen.dart';
import '../training/vhf_training_screen.dart';

/// Единая точка входа в модули F06, F09–F14.
class MaritimeToolboxScreen extends StatelessWidget {
  const MaritimeToolboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
        Text(l10n.toolboxLead, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.anchor_outlined),
          title: Text(l10n.toolboxAnchorWatch),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => push(const AnchorWatchScreen(), l10n.anchorWatchTitle),
        ),
        ListTile(
          leading: const Icon(Icons.explore_outlined),
          title: Text(l10n.toolboxCompass),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => push(const CompassAstroScreen(), l10n.compassTitle),
        ),
        ListTile(
          leading: const Icon(Icons.air_outlined),
          title: Text(l10n.toolboxGrib),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => push(const GribImportScreen(), l10n.gribTitle),
        ),
        ListTile(
          leading: const Icon(Icons.beach_access_outlined),
          title: Text(l10n.toolboxCoastal),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => push(const CoastalGuideScreen(), l10n.coastalGuideTitle),
        ),
        ListTile(
          leading: const Icon(Icons.radio_outlined),
          title: Text(l10n.toolboxVhf),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => push(const VhfTrainingScreen(), l10n.vhfTrainingTitle),
        ),
        ListTile(
          leading: const Icon(Icons.medical_services_outlined),
          title: Text(l10n.toolboxMedical),
          trailing: const Icon(Icons.chevron_right),
          onTap: () =>
              push(const MedicalGlossaryScreen(), l10n.medicalGlossaryTitle),
        ),
        ListTile(
          leading: const Icon(Icons.account_balance_wallet_outlined),
          title: Text(l10n.toolboxExpenses),
          trailing: const Icon(Icons.chevron_right),
          onTap: () =>
              push(const VoyagerCashbookScreen(), l10n.expensesTitle),
        ),
        ListTile(
          leading: const Icon(Icons.anchor_outlined),
          title: Text(l10n.moreMenuKnots),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => push(const KnotsHubScreen(), l10n.knotsTitle),
        ),
      ],
    );
  }
}
