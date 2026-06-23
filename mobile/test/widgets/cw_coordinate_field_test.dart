import 'package:captain_wrongel/widgets/cw_coordinate_field.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

void main() {
  group('CwCoordinateDms.parse', () {
    test('parses decimal minutes hemisphere format', () {
      final lat = CwCoordinateDms.parse("36°37.5'N", isLatitude: true);
      expect(lat, closeTo(36.625, 0.0001));
    });

    test('parses degrees minutes seconds format', () {
      final lat = CwCoordinateDms.parse("36°37'30\"N", isLatitude: true);
      expect(lat, closeTo(36.625, 0.0001));
    });

    test('parses padded typography-style coordinates', () {
      expect(
        CwCoordinateDms.parse("41°12.345' N", isLatitude: true),
        closeTo(41.20575, 0.0001),
      );
      expect(
        CwCoordinateDms.parse("002°34.567' E", isLatitude: false),
        closeTo(2.576117, 0.0001),
      );
    });

    test('rejects wrong hemisphere for axis', () {
      expect(CwCoordinateDms.parse("36°37.5'E", isLatitude: true), isNull);
      expect(CwCoordinateDms.parse("36°37.5'N", isLatitude: false), isNull);
    });

    test('returns null for invalid input', () {
      expect(CwCoordinateDms.parse('not a coordinate', isLatitude: true), isNull);
      expect(CwCoordinateDms.parse("91°00.000'N", isLatitude: true), isNull);
    });
  });

  group('CwCoordinateDms.format', () {
    test('round-trips parsed latitude', () {
      const input = "36°37.5'N";
      final parsed = CwCoordinateDms.parse(input, isLatitude: true)!;
      final formatted = CwCoordinateDms.format(parsed, isLatitude: true);
      final reparsed = CwCoordinateDms.parse(formatted, isLatitude: true);
      expect(reparsed, closeTo(parsed, 0.0001));
    });
  });

  group('CwCoordinateDms.parseLatLng', () {
    test('builds valid LatLng from lat and lon strings', () {
      final point = CwCoordinateDms.parseLatLng(
        lat: "36°37.5'N",
        lon: "29°06.000'E",
      );
      expect(point, isNotNull);
      final latLng = point!;
      expect(latLng, isA<LatLng>());
      expect(latLng.latitude, closeTo(36.625, 0.0001));
      expect(latLng.longitude, closeTo(29.1, 0.0001));
    });
  });
}
