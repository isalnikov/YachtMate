import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/crew/crew_controller.dart';
import '../../core/providers.dart';
import '../../core/theme/cw_tokens.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/logbook_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_button.dart';
import '../../widgets/cw_empty_state.dart';
import '../../widgets/cw_section_header.dart';
import 'logbook_providers.dart';
import 'widgets/logbook_entry_card.dart';

/// Судовой журнал — Фаза 7.1; вкладка «Ещё» или экран из меню.
class LogbookScreen extends ConsumerStatefulWidget {
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
  ConsumerState<LogbookScreen> createState() => _LogbookScreenState();
}

class _LogbookScreenState extends ConsumerState<LogbookScreen> {
  String? _categoryFilter;

  List<LogbookEntryRow> _visibleEntries(List<LogbookEntryRow> entries) {
    if (_categoryFilter == null) return entries;
    return entries.where((e) => e.category == _categoryFilter).toList();
  }

  Map<String, List<LogbookEntryRow>> _groupByCategory(
    List<LogbookEntryRow> entries,
  ) {
    final grouped = <String, List<LogbookEntryRow>>{};
    for (final entry in entries) {
      grouped.putIfAbsent(entry.category, () => []).add(entry);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final async = ref.watch(logbookEntriesProvider);
    final canDelete = ref.watch(crewControllerProvider).canCaptainActions;

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (entries) {
        final visible = _visibleEntries(entries);
        final grouped = _groupByCategory(visible);

        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!widget.compact)
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
                        CwIconButton(
                          icon: Icons.file_download_outlined,
                          semanticLabel: l10n.logbookExportCsv,
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
                        CwIconButton(
                          icon: Icons.file_download_outlined,
                          semanticLabel: l10n.logbookExportCsv,
                          onPressed: entries.isEmpty
                              ? null
                              : () => _exportCsv(context, ref, entries),
                        ),
                      ],
                    ),
                  ),
                if (entries.isNotEmpty) _CategoryFilterBar(
                  l10n: l10n,
                  selected: _categoryFilter,
                  onSelected: (value) =>
                      setState(() => _categoryFilter = value),
                ),
                Expanded(
                  child: entries.isEmpty
                      ? Center(
                          child: CwEmptyState(
                            icon: Icons.menu_book_outlined,
                            title: l10n.logbookEmpty,
                            ctaLabel: l10n.logbookAddEntry,
                            onCtaPressed: () => _openAddDialog(context, ref),
                          ),
                        )
                      : visible.isEmpty
                      ? Center(
                          child: CwEmptyState(
                            icon: Icons.filter_list_off_outlined,
                            title: l10n.logbookEmpty,
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
                          children: _categoryFilter == null
                              ? _buildSectionedList(
                                  l10n: l10n,
                                  grouped: grouped,
                                  canDelete: canDelete,
                                )
                              : _buildFlatList(
                                  l10n: l10n,
                                  entries: visible,
                                  canDelete: canDelete,
                                ),
                        ),
                ),
              ],
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: CwFab(
                icon: Icons.add,
                semanticLabel: l10n.logbookAddEntry,
                onPressed: () => _openAddDialog(context, ref),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildFlatList({
    required AppLocalizations l10n,
    required List<LogbookEntryRow> entries,
    required bool canDelete,
  }) {
    return [
      for (final entry in entries)
        LogbookEntryCard(
          entry: entry,
          categoryLabel: LogbookScreen.categoryTitle(l10n, entry.category),
          showDelete: canDelete,
          onDelete: () => _confirmDelete(context, ref, entry, canDelete),
        ),
    ];
  }

  List<Widget> _buildSectionedList({
    required AppLocalizations l10n,
    required Map<String, List<LogbookEntryRow>> grouped,
    required bool canDelete,
  }) {
    final widgets = <Widget>[];
    for (final category in LogbookEntryCategories.all) {
      final sectionEntries = grouped[category];
      if (sectionEntries == null || sectionEntries.isEmpty) continue;

      widgets.add(
        CwSectionHeader(
          label: LogbookScreen.categoryTitle(l10n, category),
        ),
      );
      widgets.addAll(
        sectionEntries.map(
          (entry) => LogbookEntryCard(
            entry: entry,
            categoryLabel: LogbookScreen.categoryTitle(l10n, entry.category),
            showDelete: canDelete,
            onDelete: () => _confirmDelete(context, ref, entry, canDelete),
          ),
        ),
      );
    }
    return widgets;
  }

  Future<void> _openAddDialog(BuildContext context, WidgetRef ref) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => const _AddLogbookEntryDialog(),
    );
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

class _AddLogbookEntryDialog extends ConsumerStatefulWidget {
  const _AddLogbookEntryDialog();

  @override
  ConsumerState<_AddLogbookEntryDialog> createState() =>
      _AddLogbookEntryDialogState();
}

class _AddLogbookEntryDialogState extends ConsumerState<_AddLogbookEntryDialog> {
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  var _category = LogbookEntryCategories.note;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await ref.read(logbookRepositoryProvider).insertEntry(
          category: _category,
          payload: {
            if (_titleCtrl.text.trim().isNotEmpty)
              'title': _titleCtrl.text.trim(),
            if (_bodyCtrl.text.trim().isNotEmpty) 'body': _bodyCtrl.text.trim(),
          },
        );
    await ref.read(auditRepositoryProvider).record(
          sessionId: ref.read(sessionIdProvider),
          module: 'M10',
          action: 'logbook_entry_create',
          contextJson: '{"category":"$_category"}',
        );
    ref.invalidate(logbookEntriesProvider);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                  value: _category,
                  items: [
                    for (final c in LogbookEntryCategories.all)
                      DropdownMenuItem(
                        value: c,
                        child: Text(LogbookScreen.categoryTitle(l10n, c)),
                      ),
                  ],
                  onChanged: (v) => setState(() => _category = v ?? _category),
                ),
              ),
            ),
            TextField(
              controller: _titleCtrl,
              decoration: InputDecoration(labelText: l10n.logbookEntryTitle),
            ),
            TextField(
              controller: _bodyCtrl,
              decoration: InputDecoration(labelText: l10n.logbookEntryBody),
              maxLines: 4,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.logbookCancel),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(l10n.logbookSave),
        ),
      ],
    );
  }
}

class _CategoryFilterBar extends StatelessWidget {
  const _CategoryFilterBar({
    required this.l10n,
    required this.selected,
    required this.onSelected,
  });

  final AppLocalizations l10n;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final options = <(String?, String)>[
      (null, l10n.aisFilterAll),
      for (final c in LogbookEntryCategories.all)
        (c, LogbookScreen.categoryTitle(l10n, c)),
    ];

    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0.92),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: CwSpacing.s,
          vertical: CwSpacing.s,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final (value, label) in options) ...[
                Padding(
                  padding: const EdgeInsets.only(right: CwSpacing.s),
                  child: FilterChip(
                    label: Text(label),
                    selected: selected == value,
                    onSelected: (_) => onSelected(value),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
