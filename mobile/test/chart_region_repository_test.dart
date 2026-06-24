import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/chart_region_repository.dart';
import 'package:captain_wrongel/features/map/offline_chart_pack_deleter.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingDeleter implements OfflineChartPackDeleter {
  final deletedPaths = <String>[];

  @override
  Future<void> deletePackAtPath(String path) async {
    deletedPaths.add(path);
  }
}

void main() {
  test('delete removes pack via deleter then DB row', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final deleter = _RecordingDeleter();
    final repo = ChartRegionRepository(db, packDeleter: deleter);

    await repo.upsert(
      regionId: 'offline_7',
      path: 'sqlite:7',
      licenseTier: 'demo',
    );

    await repo.delete('offline_7');

    expect(deleter.deletedPaths, ['sqlite:7']);
    expect(await repo.all(), isEmpty);
  });
}
