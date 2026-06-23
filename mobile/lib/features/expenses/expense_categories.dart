import '../../l10n/app_localizations.dart';

/// Expense category keys stored in Drift (`expense_tables.dart`).
const kExpenseCategories = [
  'fuel',
  'food',
  'marina',
  'mooring_fee',
  'gear',
  'provisions',
  'other',
];

String expenseCategoryLabel(AppLocalizations l10n, String category) =>
    switch (category) {
      'fuel' => l10n.expenseCatFuel,
      'food' => l10n.expenseCatFood,
      'marina' => l10n.expenseCatMarina,
      'mooring_fee' => l10n.expenseCatMooringFee,
      'gear' => l10n.expenseCatGear,
      'provisions' => l10n.expenseCatProvisions,
      _ => l10n.expenseCatOther,
    };

String formatExpenseAmount(int amountMinor, String currency) {
  final major = (amountMinor / 100).toStringAsFixed(2);
  return '$major $currency';
}

Map<String, int> expenseTotalsByCategory(Iterable<dynamic> rows) {
  final out = <String, int>{};
  for (final row in rows) {
    final category = row.category as String;
    final amountMinor = row.amountMinor as int;
    out[category] = (out[category] ?? 0) + amountMinor;
  }
  return out;
}
