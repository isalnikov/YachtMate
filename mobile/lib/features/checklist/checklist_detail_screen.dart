import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import 'checklist_providers.dart';

class ChecklistDetailScreen extends ConsumerWidget {
  const ChecklistDetailScreen({super.key, required this.templateKey});

  final String templateKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(checklistInstanceProvider(templateKey));

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (row) {
        final items = (jsonDecode(row.itemsJson) as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (c, i) {
                  final it = items[i];
                  final done = it['done'] == true;
                  return CheckboxListTile(
                    value: done,
                    title: Text(it['label']?.toString() ?? ''),
                    onChanged: row.completed
                        ? null
                        : (v) async {
                            await ref
                                .read(checklistRepositoryProvider)
                                .setItemDone(
                                  row.id,
                                  it['id'].toString(),
                                  v ?? false,
                                );
                            ref.invalidate(
                              checklistInstanceProvider(templateKey),
                            );
                          },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: row.completed
                    ? null
                    : () async {
                        await ref
                            .read(checklistRepositoryProvider)
                            .markAllDoneAndComplete(row.id);
                        await ref
                            .read(auditRepositoryProvider)
                            .record(
                              sessionId: ref.read(sessionIdProvider),
                              module: 'M10',
                              action: 'safety_checklist_complete',
                              contextJson: '{"templateKey":"$templateKey"}',
                            );
                        ref.invalidate(checklistInstanceProvider(templateKey));
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.checklistCompletedAudit)),
                        );
                      },
                child: Text(l10n.checklistComplete),
              ),
            ),
          ],
        );
      },
    );
  }
}
