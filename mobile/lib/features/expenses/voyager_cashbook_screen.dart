import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/cw_tokens.dart';
import '../../data/local/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_bottom_sheet.dart';
import '../../widgets/cw_button.dart';
import '../../widgets/cw_chip.dart';
import '../../widgets/cw_empty_state.dart';
import '../../widgets/cw_text_field.dart';
import 'expense_categories.dart';
import 'widgets/expense_category_chips.dart';
import 'widgets/expense_entry_card.dart';
import 'widgets/expense_summary_card.dart';

final expensesListProvider = FutureProvider<List<ExpenseEntryRow>>((ref) {
  return ref.watch(expenseRepositoryProvider).allDescending();
});

/// Судовая касса / расходы рейса (F14).
class VoyagerCashbookScreen extends ConsumerStatefulWidget {
  const VoyagerCashbookScreen({super.key});

  @override
  ConsumerState<VoyagerCashbookScreen> createState() =>
      _VoyagerCashbookScreenState();
}

class _VoyagerCashbookScreenState extends ConsumerState<VoyagerCashbookScreen> {
  String? _categoryFilter;

  List<ExpenseEntryRow> _filterRows(List<ExpenseEntryRow> rows) {
    if (_categoryFilter == null) return rows;
    return rows
        .where((r) => r.category == _categoryFilter)
        .toList(growable: false);
  }

  Future<void> _deleteEntry(ExpenseEntryRow row) async {
    await ref.read(expenseRepositoryProvider).deleteEntry(row.id);
    ref.invalidate(expensesListProvider);
    await ref.read(auditRepositoryProvider).record(
          sessionId: ref.read(sessionIdProvider),
          module: 'F14',
          action: 'expense_delete',
          contextJson: '{"id":"${row.id}"}',
        );
  }

  Future<void> _openAdd(BuildContext context, AppLocalizations l10n) async {
    final draft = await showCwBottomSheet<_ExpenseDraft>(
      context: context,
      title: l10n.expenseAdd,
      child: _ExpenseAddForm(l10n: l10n),
    );
    if (draft == null || !context.mounted) return;

    final id = await ref.read(expenseRepositoryProvider).addEntry(
          category: draft.category,
          amountMinor: draft.amountMinor,
          note: draft.note,
        );
    ref.invalidate(expensesListProvider);
    await ref.read(auditRepositoryProvider).record(
          sessionId: ref.read(sessionIdProvider),
          module: 'F14',
          action: 'expense_add',
          contextJson:
              '{"id":"$id","category":"${draft.category}","minor":${draft.amountMinor}}',
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(expensesListProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, st) => Center(child: Text(l10n.expensesLoadError)),
      data: (rows) {
        final totals = expenseTotalsByCategory(rows);
        final currency = rows.isNotEmpty ? rows.first.currency : 'EUR';
        final filtered = _filterRows(rows);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                CwSpacing.m,
                CwSpacing.s,
                CwSpacing.m,
                0,
              ),
              child: Text(
                l10n.expensesDisclaimer,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            ExpenseSummaryCard(
              totalsByCategory: totals,
              currency: currency,
            ),
            ExpenseCategoryChips(
              selected: _categoryFilter,
              onSelected: (value) => setState(() => _categoryFilter = value),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: CwEmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: l10n.expenseEmpty,
                        ctaLabel: rows.isEmpty ? l10n.expenseAdd : null,
                        onCtaPressed:
                            rows.isEmpty ? () => _openAdd(context, l10n) : null,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: CwSpacing.s),
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) {
                        final row = filtered[i];
                        return ExpenseEntryCard(
                          entry: row,
                          categoryLabel:
                              expenseCategoryLabel(l10n, row.category),
                          onDelete: () => _deleteEntry(row),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(CwSpacing.m),
              child: CwButton(
                key: const Key('expense_add_button'),
                label: l10n.expenseAdd,
                icon: Icons.add,
                onPressed: () => _openAdd(context, l10n),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ExpenseDraft {
  const _ExpenseDraft({
    required this.category,
    required this.amountMinor,
    this.note,
  });

  final String category;
  final int amountMinor;
  final String? note;
}

class _ExpenseAddForm extends StatefulWidget {
  const _ExpenseAddForm({required this.l10n});

  final AppLocalizations l10n;

  @override
  State<_ExpenseAddForm> createState() => _ExpenseAddFormState();
}

class _ExpenseAddFormState extends State<_ExpenseAddForm> {
  var _category = kExpenseCategories.first;
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final raw = _amountCtrl.text.replaceAll(',', '.');
    final val = double.tryParse(raw);
    if (val == null) return;
    final minor = (val * 100).round();
    Navigator.of(context).pop(
      _ExpenseDraft(
        category: _category,
        amountMinor: minor,
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: CwSpacing.xs,
          runSpacing: CwSpacing.xs,
          children: [
            for (final category in kExpenseCategories)
              CwChip(
                key: Key('expense_add_category_$category'),
                label: expenseCategoryLabel(l10n, category),
                selected: _category == category,
                onSelected: (_) => setState(() => _category = category),
              ),
          ],
        ),
        const SizedBox(height: CwSpacing.m),
        CwTextField(
          key: const Key('expense_add_amount'),
          controller: _amountCtrl,
          label: l10n.expenseAmount,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
          ],
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: CwSpacing.m),
        CwTextField(
          key: const Key('expense_add_note'),
          controller: _noteCtrl,
          label: l10n.expenseNote,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _save(),
        ),
        const SizedBox(height: CwSpacing.l),
        CwButton(
          key: const Key('expense_add_save'),
          label: l10n.expenseSave,
          icon: Icons.check,
          onPressed: _save,
        ),
      ],
    );
  }
}
