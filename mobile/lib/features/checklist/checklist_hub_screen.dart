import 'package:flutter/material.dart';

import '../../core/theme/cw_theme_extensions.dart';
import '../../core/theme/cw_tokens.dart';
import '../../core/theme/cw_typography.dart';
import '../../domain/checklist/checklist_templates.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_app_bar.dart';
import '../../widgets/cw_card.dart';
import 'checklist_detail_screen.dart';

class ChecklistHubScreen extends StatelessWidget {
  const ChecklistHubScreen({super.key});

  static const _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: CwSpacing.s,
    crossAxisSpacing: CwSpacing.s,
    childAspectRatio: 1.15,
  );

  static IconData _iconFor(String key) => switch (key) {
    ChecklistTemplateKeys.departure => Icons.sailing_outlined,
    ChecklistTemplateKeys.docking => Icons.dock_outlined,
    ChecklistTemplateKeys.storm => Icons.thunderstorm_outlined,
    _ => Icons.checklist_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;

    String title(String key) => switch (key) {
      ChecklistTemplateKeys.departure => l10n.checklistTplDeparture,
      ChecklistTemplateKeys.docking => l10n.checklistTplDocking,
      ChecklistTemplateKeys.storm => l10n.checklistTplStorm,
      _ => key,
    };

    int itemCount(String key) =>
        checklistSeedItemsEn()[key]?.length ?? 0;

    void openDetail(String key) {
      final label = title(key);
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            appBar: CwAppBar(title: label),
            body: ChecklistDetailScreen(templateKey: key),
          ),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(CwSpacing.m),
          sliver: SliverGrid(
            gridDelegate: _gridDelegate,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final key = ChecklistTemplateKeys.all.elementAt(index);
                final count = itemCount(key);
                return Semantics(
                  button: true,
                  label: title(key),
                  child: CwCard(
                    key: Key('checklist_hub_$key'),
                    onTap: () => openDetail(key),
                    padding: const EdgeInsets.all(CwSpacing.m),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          _iconFor(key),
                          size: 32,
                          color: colors.accentTeal,
                        ),
                        const Spacer(),
                        Text(
                          title(key),
                          style: CwTypography.h2(color: colors.textPrimary),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (count > 0) ...[
                          const SizedBox(height: CwSpacing.xs),
                          Text(
                            '$count items',
                            style: CwTypography.caption(
                              color: colors.textMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
              childCount: ChecklistTemplateKeys.all.length,
            ),
          ),
        ),
      ],
    );
  }
}
