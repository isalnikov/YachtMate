import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/audit_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('record persists user_action_audit row', () async {
    final repo = AuditRepository(db);
    final id = await repo.record(
      sessionId: 'sess-1',
      module: 'core',
      action: 'test_action',
      contextJson: '{"k":1}',
    );
    expect(id, greaterThan(0));

    final rows = await db.select(db.userActionAudits).get();
    expect(rows, hasLength(1));
    expect(rows.single.sessionId, 'sess-1');
    expect(rows.single.module, 'core');
    expect(rows.single.action, 'test_action');
    expect(rows.single.contextJson, '{"k":1}');
  });
}
