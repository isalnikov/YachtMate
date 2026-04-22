import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/app_database.dart';

class ExpenseRepository {
  ExpenseRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  Future<String> addEntry({
    required String category,
    required int amountMinor,
    String currency = 'EUR',
    String? note,
  }) async {
    final id = _uuid.v4();
    final t = DateTime.now().millisecondsSinceEpoch;
    await _db.into(_db.expenseEntries).insert(
          ExpenseEntriesCompanion.insert(
            id: id,
            t: t,
            category: category,
            amountMinor: amountMinor,
            currency: Value(currency),
            note: Value(note),
          ),
        );
    return id;
  }

  Future<void> deleteEntry(String id) async {
    await (_db.delete(_db.expenseEntries)..where((e) => e.id.equals(id))).go();
  }

  Future<List<ExpenseEntryRow>> allDescending() async {
    return (_db.select(_db.expenseEntries)
          ..orderBy([(t) => OrderingTerm.desc(t.t)]))
        .get();
  }

  Future<Map<String, int>> totalsByCategory() async {
    final rows = await _db.select(_db.expenseEntries).get();
    final out = <String, int>{};
    for (final r in rows) {
      out[r.category] = (out[r.category] ?? 0) + r.amountMinor;
    }
    return out;
  }
}
