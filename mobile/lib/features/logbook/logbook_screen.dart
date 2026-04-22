import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/crew/crew_controller.dart';
import '../../core/providers.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/logbook_repository.dart';
import '../../l10n/app_localizations.dart';
import 'logbook_providers.dart';

/// Судовой журнал — Фаза 7.1; вкладка «Ещё» или экран из меню.
class LogbookScreen extends ConsumerWidget {
  const LogbookScreen({super.key, this.compact = false});

  /// Без второго заголовка (родитель уже дал [AppBar]).
  final bool compact;

  static String categoryTitle(AppLocalizations l10n, String c) {
    return switch (c) {
      LogbookEntryCategories.note => l10n.logbookCategoryNote,
      LogbookEntryCategories.fuel => l10n.logbookCategoryFuel,
      LogbookEntryCategories.maintenance => l10n.logbookCategoryMaintenance,
      LogbookEntryCategories.watch => l10n.logbookCategoryWatch,
      LogbookEntryCategories.other => l10n.logbookCategoryOther,
      _ => c,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final async = ref.watch(logbookEntriesProvider);
    final canDelete = ref.watch(crewControllerProvider).canCaptainActions;

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (entries) {
        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!compact)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.logbookTitle,
                            style: theme.textTheme.headlineSmall,
                          ),
                        ),
                        IconButton(
                          tooltip: l10n.logbookExportCsv,
                          icon: const Icon(Icons.file_download_outlined),
                          onPressed: entries.isEmpty
                              ? null
                              : () => _exportCsv(context, ref, entries),
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          tooltip: l10n.logbookExportCsv,
                          icon: const Icon(Icons.file_download_outlined),
                          onPressed: entries.isEmpty
                              ? null
                              : () => _exportCsv(context, ref, entries),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: entries.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              l10n.logbookEmpty,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: entries.length,
                          separatorBuilder: (_, index) =>
                              const Divider(height: 1),
                          itemBuilder: (ctx, i) {
                            final e = entries[i];
                            return _LogbookTile(
                              entry: e,
                              categoryLabel: categoryTitle(l10n, e.category),
                              showDelete: canDelete,
                              onDelete: () =>
                                  _confirmDelete(context, ref, e, canDelete),
                            );
                          },
                        ),
                ),
              ],
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton.extended(
                onPressed: () => _openAddDialog(context, ref),
                icon: const Icon(Icons.add),
                label: Text(l10n.logbookAddEntry),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openAddDialog(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    var category = LogbookEntryCategories.note;

    try {
      await showDialog<void>(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (ctx, setLocal) {
              return AlertDialog(
                title: Text(l10n.logbookAddEntry),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: l10n.logbookCategory,
                          border: const OutlineInputBorder(),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: category,
                            items: [
                              for (final c in LogbookEntryCategories.all)
                                DropdownMenuItem(
                                  value: c,
                                  child: Text(categoryTitle(l10n, c)),
                                ),
                            ],
                            onChanged: (v) =>
                                setLocal(() => category = v ?? category),
                          ),
                        ),
                      ),
                      TextField(
                        controller: titleCtrl,
                        decoration: InputDecoration(
                          labelText: l10n.logbookEntryTitle,
                        ),
                      ),
                      TextField(
                        controller: bodyCtrl,
                        decoration: InputDecoration(
                          labelText: l10n.logbookEntryBody,
                        ),
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(l10n.logbookCancel),
                  ),
                  FilledButton(
                    onPressed: () async {
                      await ref
                          .read(logbookRepositoryProvider)
                          .insertEntry(
                            category: category,
                            payload: {
                              if (titleCtrl.text.trim().isNotEmpty)
                                'title': titleCtrl.text.trim(),
                              if (bodyCtrl.text.trim().isNotEmpty)
                                'body': bodyCtrl.text.trim(),
                            },
                          );
                      await ref
                          .read(auditRepositoryProvider)
                          .record(
                            sessionId: ref.read(sessionIdProvider),
                            module: 'M10',
                            action: 'logbook_entry_create',
                            contextJson: '{"category":"$category"}',
                          );
                      ref.invalidate(logbookEntriesProvider);
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    child: Text(l10n.logbookSave),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      titleCtrl.dispose();
      bodyCtrl.dispose();
    }
  }

  Future<void> _exportCsv(
    BuildContext context,
    WidgetRef ref,
    List<LogbookEntryRow> rows,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.maybeOf(context);
    final repo = ref.read(logbookRepositoryProvider);
    final csv = repo.exportCsv(rows);

    try {
      await Clipboard.setData(ClipboardData(text: csv));

      await ref
          .read(auditRepositoryProvider)
          .record(
            sessionId: ref.read(sessionIdProvider),
            module: 'M10',
            action: 'logbook_export_csv',
            contextJson:
                '{"entryCount":${rows.length},"fileBytes":${csv.length}}',
          );

      if (!context.mounted) return;
      messenger?.showSnackBar(
        SnackBar(content: Text(l10n.logbookExportCopied)),
      );
    } catch (e) {
      if (!context.mounted) return;
      messenger?.showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    LogbookEntryRow e,
    bool canDelete,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    if (!canDelete) {
      ScaffoldMessenger.maybeOf(
        context,
      )?.showSnackBar(SnackBar(content: Text(l10n.logbookCrewNoDelete)));
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.logbookDeleteTitle),
        content: Text(l10n.logbookDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.logbookCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.logbookDelete),
          ),
        ],
      ),
    );
    if (ok != true) return;

    await ref.read(logbookRepositoryProvider).deleteEntry(e.id);
    await ref
        .read(auditRepositoryProvider)
        .record(
          sessionId: ref.read(sessionIdProvider),
          module: 'M10',
          action: 'logbook_entry_delete',
          contextJson: '{"category":"${e.category}"}',
        );
    ref.invalidate(logbookEntriesProvider);

    if (!context.mounted) return;
    ScaffoldMessenger.maybeOf(
      context,
    )?.showSnackBar(SnackBar(content: Text(l10n.logbookEntryDeleted)));
  }
}

class _LogbookTile extends StatelessWidget {
  const _LogbookTile({
    required this.entry,
    required this.categoryLabel,
    required this.showDelete,
    required this.onDelete,
  });

  final LogbookEntryRow entry;
  final String categoryLabel;
  final bool showDelete;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final payload = LogbookPayload.parse(entry.payloadJson);
    final titleText = (payload.title ?? '').trim();
    final when = DateFormat.yMMMd().add_Hm().format(
      DateTime.fromMillisecondsSinceEpoch(entry.t),
    );

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      title: Text(titleText.isNotEmpty ? titleText : categoryLabel),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$categoryLabel · $when',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          if ((payload.body ?? '').trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                payload.body!,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
      trailing: showDelete
          ? IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            )
          : null,
    );
  }
}

class LogbookPayload {
  LogbookPayload({this.title, this.body});

  final String? title;
  final String? body;

  static LogbookPayload parse(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return LogbookPayload(
          title: decoded['title']?.toString(),
          body: decoded['body']?.toString(),
        );
      }
    } catch (_) {}
    return LogbookPayload();
  }
}
