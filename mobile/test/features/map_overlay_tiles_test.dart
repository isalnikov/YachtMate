import 'package:captain_wrongel/features/map/map_layer_kinds.dart';
import 'package:captain_wrongel/features/map/map_tile_overlay_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('overlayTileConfigFor', () {
    test('none returns null', () {
      expect(overlayTileConfigFor(MapOverlayKind.none), isNull);
    });

    test('satellite uses Esri World Imagery template', () {
      final config = overlayTileConfigFor(MapOverlayKind.satellite)!;
      expect(config.isValid, isTrue);
      expect(
        config.tiles.single,
        contains('World_Imagery'),
      );
      expect(config.rasterOpacity, 1.0);
    });

    test('reliefShading uses hillshade raster placeholder', () {
      final config = overlayTileConfigFor(MapOverlayKind.reliefShading)!;
      expect(config.isValid, isTrue);
      expect(
        config.tiles.single,
        contains('World_Hillshade'),
      );
      expect(config.rasterOpacity, lessThan(1.0));
    });

    test('sonar uses semi-transparent placeholder raster', () {
      final config = overlayTileConfigFor(MapOverlayKind.sonar)!;
      expect(config.isValid, isTrue);
      expect(
        config.tiles.single,
        contains('World_Ocean_Reference'),
      );
      expect(config.rasterOpacity, greaterThan(0));
      expect(config.rasterOpacity, lessThan(1.0));
      expect(config.attribution, contains('placeholder'));
    });
  });

  group('MapOverlayTileConfig', () {
    test('isValid is false when tiles list is empty', () {
      const config = MapOverlayTileConfig(tiles: []);
      expect(config.isValid, isFalse);
    });

    test('isValid is false when tile URL is blank', () {
      const config = MapOverlayTileConfig(tiles: ['   ']);
      expect(config.isValid, isFalse);
    });
  });

  group('overlay ids', () {
    test('source and layer ids are stable', () {
      expect(cwMapOverlaySourceId, 'cw_map_overlay_raster');
      expect(cwMapOverlayLayerId, 'cw_map_overlay_raster_layer');
    });
  });
}
