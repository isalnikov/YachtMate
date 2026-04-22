import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/checklist_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ChecklistRepository getOrCreate and complete', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final r = ChecklistRepository(db);
    final row = await r.getOrCreateInstance(
      templateKey: 'departure',
      seeds: const [
        ChecklistItemSeed(id: 'a', label: 'A'),
        ChecklistItemSeed(id: 'b', label: 'B'),
      ],
    );
    expect(row.completed, false);
    await r.setItemDone(row.id, 'a', true);
    final again = await r.instanceByTemplateKey('departure');
    expect(again!.itemsJson, contains('"done":true'));
    await r.markAllDoneAndComplete(row.id);
    final done = await r.instanceByTemplateKey('departure');
    expect(done!.completed, true);
  });
}
