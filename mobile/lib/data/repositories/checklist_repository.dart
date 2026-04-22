import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/app_database.dart';

class ChecklistItemSeed {
  const ChecklistItemSeed({required this.id, required this.label});

  final String id;
  final String label;
}

/// Редактируемые чек-листы (Фаза 7.4).
class ChecklistRepository {
  ChecklistRepository(this._db);

  final AppDatabase _db;

  static const _uuid = Uuid();

  Future<ChecklistInstanceRow> getOrCreateInstance({
    required String templateKey,
    required List<ChecklistItemSeed> seeds,
  }) async {
    final q = _db.select(_db.checklistInstances)
      ..where((c) => c.templateKey.equals(templateKey));
    final row = await q.getSingleOrNull();
    if (row != null) return row;

    final id = _uuid.v4();
    final now = DateTime.now().millisecondsSinceEpoch;
    final items = [
      for (final s in seeds)
        <String, dynamic>{'id': s.id, 'label': s.label, 'done': false},
    ];
    await _db
        .into(_db.checklistInstances)
        .insert(
          ChecklistInstancesCompanion.insert(
            id: id,
            templateKey: templateKey,
            itemsJson: jsonEncode(items),
            updatedAtMs: now,
            completed: const Value(false),
          ),
        );
    return await (_db.select(
      _db.checklistInstances,
    )..where((c) => c.id.equals(id))).getSingle();
  }

  Future<ChecklistInstanceRow?> instanceByTemplateKey(String key) {
    return (_db.select(
      _db.checklistInstances,
    )..where((c) => c.templateKey.equals(key))).getSingleOrNull();
  }

  Future<void> setItemDone(String instanceId, String itemId, bool done) async {
    final row = await (_db.select(
      _db.checklistInstances,
    )..where((c) => c.id.equals(instanceId))).getSingle();
    final list = (jsonDecode(row.itemsJson) as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    for (var i = 0; i < list.length; i++) {
      if (list[i]['id'] == itemId) {
        list[i] = {...list[i], 'done': done};
        break;
      }
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(
      _db.checklistInstances,
    )..where((c) => c.id.equals(row.id))).write(
      ChecklistInstancesCompanion(
        itemsJson: Value(jsonEncode(list)),
        updatedAtMs: Value(now),
      ),
    );
  }

  Future<void> markAllDoneAndComplete(String instanceId) async {
    final row = await (_db.select(
      _db.checklistInstances,
    )..where((c) => c.id.equals(instanceId))).getSingle();
    final list = (jsonDecode(row.itemsJson) as List<dynamic>).map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      m['done'] = true;
      return m;
    }).toList();
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(
      _db.checklistInstances,
    )..where((c) => c.id.equals(row.id))).write(
      ChecklistInstancesCompanion(
        itemsJson: Value(jsonEncode(list)),
        updatedAtMs: Value(now),
        completed: const Value(true),
      ),
    );
  }
}
