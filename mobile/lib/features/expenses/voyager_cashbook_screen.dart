import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/local/app_database.dart';
import '../../l10n/app_localizations.dart';

final expensesListProvider = FutureProvider<List<ExpenseEntryRow>>((ref) {
  return ref.watch(expenseRepositoryProvider).allDescending();
});

/// Судовая касса / расходы рейса (F14).
class VoyagerCashbookScreen extends ConsumerWidget {
  const VoyagerCashbookScreen({super.key});

  static const _cats = [
    'fuel',
    'food',
    'marina',
    'mooring_fee',
    'gear',
    'provisions',
    'other',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(expensesListProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, st) => Center(child: Text(l10n.expensesLoadError)),
      data: (rows) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(l10n.expensesDisclaimer,
                  style: Theme.of(context).textTheme.bodySmall),
            ),
            Expanded(
              child: rows.isEmpty
                  ? Center(child: Text(l10n.expenseEmpty))
                  : ListView.builder(
                      itemCount: rows.length,
                      itemBuilder: (ctx, i) {
                        final r = rows[i];
                        final amt = (r.amountMinor / 100).toStringAsFixed(2);
                        return ListTile(
                          title: Text(
                            '${_catLabel(l10n, r.category)} · $amt ${r.currency}',
                          ),
                          subtitle:
                              r.note != null ? Text(r.note!) : null,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              await ref
                                  .read(expenseRepositoryProvider)
                                  .deleteEntry(r.id);
                              ref.invalidate(expensesListProvider);
                              await ref.read(auditRepositoryProvider).record(
                                    sessionId: ref.read(sessionIdProvider),
                                    module: 'F14',
                                    action: 'expense_delete',
                                    contextJson: '{"id":"${r.id}"}',
                                  );
                            },
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.icon(
                onPressed: () => _openAdd(context, ref, l10n),
                icon: const Icon(Icons.add),
                label: Text(l10n.expenseAdd),
              ),
            ),
          ],
        );
      },
    );
  }

  String _catLabel(AppLocalizations l10n, String c) => switch (c) {
        'fuel' => l10n.expenseCatFuel,
        'food' => l10n.expenseCatFood,
        'marina' => l10n.expenseCatMarina,
        'mooring_fee' => l10n.expenseCatMooringFee,
        'gear' => l10n.expenseCatGear,
        'provisions' => l10n.expenseCatProvisions,
        _ => l10n.expenseCatOther,
      };

  Future<void> _openAdd(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    var cat = _cats.first;
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.expenseAdd),
        content: StatefulBuilder(
          builder: (ctx, setSt) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  key: ValueKey(cat),
                  initialValue: cat,
                  items: [
                    for (final c in _cats)
                      DropdownMenuItem(value: c, child: Text(_catLabel(l10n, c))),
                  ],
                  onChanged: (v) => setSt(() => cat = v ?? cat),
                ),
                TextField(
                  controller: amountCtrl,
                  decoration: InputDecoration(labelText: l10n.expenseAmount),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                  ],
                ),
                TextField(
                  controller: noteCtrl,
                  decoration: InputDecoration(labelText: l10n.expenseNote),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.logbookCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.expenseSave),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;

    final raw = amountCtrl.text.replaceAll(',', '.');
    final val = double.tryParse(raw);
    if (val == null) return;
    final minor = (val * 100).round();

    final id = await ref.read(expenseRepositoryProvider).addEntry(
          category: cat,
          amountMinor: minor,
          note: noteCtrl.text.isEmpty ? null : noteCtrl.text,
        );
    ref.invalidate(expensesListProvider);
    await ref.read(auditRepositoryProvider).record(
          sessionId: ref.read(sessionIdProvider),
          module: 'F14',
          action: 'expense_add',
          contextJson: '{"id":"$id","category":"$cat","minor":$minor}',
        );
  }
}
