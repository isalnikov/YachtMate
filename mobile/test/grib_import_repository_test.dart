import 'dart:io';

import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/grib_import_repository.dart';
import 'package:captain_wrongel/features/grib/grib_import_storage.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fixtures/grib/minimal_wind_fixture.dart';

void main() {
  test('importAndDecode stores result in Drift', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = GribImportRepository(db);

    final dir = await Directory.systemTemp.createTemp('cw_grib_repo_');
    final file = File('${dir.path}/wind.grb2');
    await file.writeAsBytes(buildMinimalWindUvGrib2());
    addTearDown(() => dir.delete(recursive: true));

    final decoded = await repo.importAndDecode(file.path);
    expect(decoded.isDecoded, isTrue);
    expect(decoded.decodeSummary, contains('grid'));

    final listed = await repo.listAll();
    expect(listed, hasLength(1));
    expect(listed.single.path, file.path);
    expect(listed.single.decodeSummary, decoded.decodeSummary);
  });

  test('listAll does not re-decode files on disk', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = GribImportRepository(db);

    final dir = await Directory.systemTemp.createTemp('cw_grib_repo2_');
    final file = File('${dir.path}/wind.grb2');
    await file.writeAsBytes(buildMinimalWindUvGrib2());
    addTearDown(() => dir.delete(recursive: true));

    await repo.importAndDecode(file.path);
    await file.delete();

    final listed = await repo.listAll();
    expect(listed.single.decodeSummary, isNotNull);
    expect(listed.single.decodeError, isNull);
  });

  test('migrateLegacyPrefs imports prefs paths once then clears keys', () async {
    SharedPreferences.setMockInitialValues({
      gribLegacyPathPrefsKey: '/missing/legacy.grb',
    });
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = GribImportRepository(db);

    await repo.migrateLegacyPrefs(prefs);

    expect(prefs.getString(gribLegacyPathPrefsKey), isNull);
    final listed = await repo.listAll();
    expect(listed, hasLength(1));
    expect(listed.single.decodeError, isNotNull);
  });
}
