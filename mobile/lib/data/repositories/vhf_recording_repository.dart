import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/app_database.dart';

class VhfRecordingRepository {
  VhfRecordingRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  Future<String> insertMeta({
    required String path,
    int? durationMs,
    String? transcript,
  }) async {
    final id = _uuid.v4();
    final t = DateTime.now().millisecondsSinceEpoch;
    await _db.into(_db.vhfRecordings).insert(
          VhfRecordingsCompanion.insert(
            id: id,
            t: t,
            path: path,
            durationMs: Value(durationMs),
            transcript: Value(transcript),
          ),
        );
    return id;
  }

  Future<void> setTranscript(String id, String text) async {
    await (_db.update(_db.vhfRecordings)..where((r) => r.id.equals(id))).write(
          VhfRecordingsCompanion(transcript: Value(text)),
        );
  }

  Future<List<VhfRecordingRow>> allDescending() async {
    return (_db.select(_db.vhfRecordings)
          ..orderBy([(t) => OrderingTerm.desc(t.t)]))
        .get();
  }

  Future<void> deleteRecording(String id) async {
    await (_db.delete(_db.vhfRecordings)..where((r) => r.id.equals(id))).go();
  }
}
