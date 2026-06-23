import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/cw_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_button.dart';
import '../../widgets/cw_card.dart';
import '../../widgets/cw_checkbox.dart';
import 'checklist_providers.dart';
import 'widgets/checklist_progress.dart';

class ChecklistDetailScreen extends ConsumerWidget {
  const ChecklistDetailScreen({super.key, required this.templateKey});

  final String templateKey;

  static List<Map<String, dynamic>> _parseItems(String itemsJson) {
    return (jsonDecode(itemsJson) as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  static int _doneCount(List<Map<String, dynamic>> items) =>
      items.where((it) => it['done'] == true).length;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(checklistInstanceProvider(templateKey));

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, _) => Center(child: Text('$e')),
      data: (row) {
        final items = _parseItems(row.itemsJson);
        final done = _doneCount(items);
        final locked = row.completed;

        return Column(
          children: [
            ChecklistProgress(done: done, total: items.length),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: CwSpacing.m),
                children: [
                  CwCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: CwSpacing.m,
                      vertical: CwSpacing.s,
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < items.length; i++) ...[
                          if (i > 0) const Divider(height: 1),
                          CwCheckbox(
                            key: Key(
                              'checklist_item_${items[i]['id']}',
                            ),
                            value: items[i]['done'] == true,
                            label: items[i]['label']?.toString() ?? '',
                            onChanged: locked
                                ? null
                                : (checked) async {
                                    await ref
                                        .read(checklistRepositoryProvider)
                                        .setItemDone(
                                          row.id,
                                          items[i]['id'].toString(),
                                          checked,
                                        );
                                    ref.invalidate(
                                      checklistInstanceProvider(templateKey),
                                    );
                                  },
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(CwSpacing.m),
              child: CwButton(
                label: l10n.checklistComplete,
                onPressed: locked
                    ? null
                    : () async {
                        await ref
                            .read(checklistRepositoryProvider)
                            .markAllDoneAndComplete(row.id);
                        await ref.read(auditRepositoryProvider).record(
                              sessionId: ref.read(sessionIdProvider),
                              module: 'M10',
                              action: 'safety_checklist_complete',
                              contextJson: '{"templateKey":"$templateKey"}',
                            );
                        ref.invalidate(checklistInstanceProvider(templateKey));
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.checklistCompletedAudit),
                          ),
                        );
                      },
              ),
            ),
          ],
        );
      },
    );
  }
}
