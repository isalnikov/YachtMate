import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/logbook_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('insert list order and exportCsv', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = LogbookRepository(db);

    await repo.insertEntry(
      category: LogbookEntryCategories.note,
      payload: {'title': 'A', 'body': 'first'},
    );
    await Future<void>.delayed(Duration.zero);
    await repo.insertEntry(
      category: LogbookEntryCategories.fuel,
      payload: {'title': 'B', 'body': 'liters'},
    );

    final rows = await repo.entriesNewestFirst();
    expect(rows, hasLength(2));
    expect(rows.first.payloadJson, contains('B'));
    expect(rows.last.payloadJson, contains('A'));

    final csv = repo.exportCsv(rows);
    expect(csv, contains('fuel'));
    expect(csv, contains('"B"'));
  });

  test('exportCsv escapes quotes in body', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = LogbookRepository(db);

    await repo.insertEntry(
      category: LogbookEntryCategories.other,
      payload: {'title': 'x', 'body': 'say "hello"'},
    );

    final rows = await repo.entriesNewestFirst();
    final csv = repo.exportCsv(rows);
    expect(csv, contains('""hello""'));
  });

  test('deleteEntry removes row', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = LogbookRepository(db);

    await repo.insertEntry(
      category: LogbookEntryCategories.maintenance,
      payload: {'title': 'oil'},
    );
    final id = (await repo.entriesNewestFirst()).single.id;

    await repo.deleteEntry(id);
    expect(await repo.entriesNewestFirst(), isEmpty);
  });
}
