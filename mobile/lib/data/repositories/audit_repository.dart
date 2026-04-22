import 'package:drift/drift.dart';

import '../local/app_database.dart';

/// Inserts rows into [UserActionAudits]. All significant user actions go through here.
class AuditRepository {
  AuditRepository(this._db);

  final AppDatabase _db;

  /// Persists one audit record. [contextJson] must avoid PII by default (plan §5.2).
  Future<int> record({
    required String sessionId,
    required String module,
    required String action,
    String severity = 'info',
    String? contextJson,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return _db
        .into(_db.userActionAudits)
        .insert(
          UserActionAuditsCompanion.insert(
            t: now,
            sessionId: sessionId,
            module: module,
            action: action,
            severity: Value(severity),
            contextJson: contextJson != null
                ? Value(contextJson)
                : const Value.absent(),
          ),
        );
  }
}
