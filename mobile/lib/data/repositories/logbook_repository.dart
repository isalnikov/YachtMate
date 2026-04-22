import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/app_database.dart';

/// Категории записей журнала (Фаза 7 — безопасность и журнал).
abstract final class LogbookEntryCategories {
  static const note = 'note';
  static const fuel = 'fuel';
  static const maintenance = 'maintenance';
  static const watch = 'watch';
  static const other = 'other';

  static const Iterable<String> all = [note, fuel, maintenance, watch, other];
}

/// Локальный судовой журнал — SQLite, без синка (позже §7.6).
class LogbookRepository {
  LogbookRepository(this._db);

  final AppDatabase _db;

  static const _uuid = Uuid();

  Future<void> insertEntry({
    required String category,
    required Map<String, dynamic> payload,
    DateTime? at,
  }) async {
    final id = _uuid.v4();
    final ms = (at ?? DateTime.now()).millisecondsSinceEpoch;
    await _db
        .into(_db.logbookEntries)
        .insert(
          LogbookEntriesCompanion.insert(
            id: id,
            t: ms,
            category: category,
            payloadJson: jsonEncode(payload),
          ),
        );
  }

  Future<List<LogbookEntryRow>> entriesNewestFirst() {
    return (_db.select(
      _db.logbookEntries,
    )..orderBy([(e) => OrderingTerm.desc(e.t)])).get();
  }

  Future<void> deleteEntry(String id) async {
    await (_db.delete(_db.logbookEntries)..where((e) => e.id.equals(id))).go();
  }

  /// Строки CSV с заголовком; время в UTC ISO 8601.
  String exportCsv(Iterable<LogbookEntryRow> rows) {
    final header = 'id,time_utc_iso,category,title,body';
    final lines = <String>[header];
    for (final r in rows) {
      Map<String, dynamic> payload = {};
      try {
        final d = jsonDecode(r.payloadJson);
        if (d is Map<String, dynamic>) payload = d;
      } catch (_) {}
      final title = payload['title']?.toString() ?? '';
      final body = payload['body']?.toString() ?? '';
      lines.add(
        [
          _csvCell(r.id),
          _csvCell(
            DateTime.fromMillisecondsSinceEpoch(
              r.t,
              isUtc: true,
            ).toIso8601String(),
          ),
          _csvCell(r.category),
          _csvCell(title),
          _csvCell(body),
        ].join(','),
      );
    }
    return '${lines.join('\n')}\n';
  }

  static String _csvCell(String raw) {
    final escaped = raw.replaceAll('"', '""');
    return '"$escaped"';
  }
}
