import 'dart:io';
import 'dart:typed_data';

import 'package:captain_wrongel/domain/grib/grib_decoder.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixtures/grib/minimal_wind_fixture.dart';

void main() {
  group('GribDecoder', () {
    test('decodeBytes reads grid metadata from minimal fixture', () {
      final bytes = buildMinimalWindGrib2();
      final result = GribDecoder.decodeBytes(bytes);

      expect(result.isOk, isTrue);
      expect(result.messages, hasLength(1));

      final msg = result.messages.single;
      expect(msg.parameterLabel, 'U wind');
      expect(msg.grid.ni, 2);
      expect(msg.grid.nj, 2);
      expect(msg.grid.latMin, closeTo(40, 0.001));
      expect(msg.grid.latMax, closeTo(41, 0.001));
      expect(msg.grid.lonMin, closeTo(10, 0.001));
      expect(msg.grid.lonMax, closeTo(11, 0.001));
      expect(msg.referenceTimeUtc, DateTime.utc(2024, 6, 15, 12));
      expect(result.summaryLabel, contains('2×2 grid'));
    });

    test('decodeBytes unpacks simple-packed values', () {
      final bytes = buildMinimalWindGrib2();
      final result = GribDecoder.decodeBytes(bytes);

      expect(result.messages.single.values, [1, 2, 3, 4]);
    });

    test('windAtPoint interpolates U/V from combined fixture', () {
      final bytes = buildMinimalWindUvGrib2();
      final result = GribDecoder.decodeBytes(bytes);

      expect(result.messages, hasLength(2));

      final sample = GribDecoder.windAtPoint(
        result: result,
        lat: 40.5,
        lon: 10.5,
      );

      expect(sample, isNotNull);
      expect(sample!.uMs, closeTo(2.5, 0.01));
      expect(sample.vMs, closeTo(0.5, 0.01));
    });

    test('decodeFile loads bytes from disk', () async {
      final bytes = buildMinimalWindGrib2();
      final file = File(
        '${Directory.systemTemp.path}/cw_grib_test_${DateTime.now().microsecondsSinceEpoch}.grb2',
      );
      await file.writeAsBytes(bytes);

      addTearDown(() {
        if (file.existsSync()) file.deleteSync();
      });

      final result = await GribDecoder.decodeFile(file.path);
      expect(result.isOk, isTrue);
      expect(result.messages.single.isWindU, isTrue);
    });

    test('decodeBytes returns error for invalid magic', () {
      final result = GribDecoder.decodeBytes(Uint8List.fromList([1, 2, 3, 4]));
      expect(result.isOk, isFalse);
      expect(result.error, isNotNull);
    });
  });
}
