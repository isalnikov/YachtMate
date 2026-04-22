import 'package:flutter/material.dart';

import '../../domain/checklist/checklist_templates.dart';
import '../../l10n/app_localizations.dart';
import 'checklist_detail_screen.dart';

class ChecklistHubScreen extends StatelessWidget {
  const ChecklistHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    String title(String key) => switch (key) {
      ChecklistTemplateKeys.departure => l10n.checklistTplDeparture,
      ChecklistTemplateKeys.docking => l10n.checklistTplDocking,
      ChecklistTemplateKeys.storm => l10n.checklistTplStorm,
      _ => key,
    };

    return ListView(
      children: [
        for (final k in ChecklistTemplateKeys.all)
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: Text(title(k)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => Scaffold(
                  appBar: AppBar(title: Text(title(k))),
                  body: ChecklistDetailScreen(templateKey: k),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
