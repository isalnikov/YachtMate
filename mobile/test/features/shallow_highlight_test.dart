import 'package:captain_wrongel/core/theme/cw_tokens.dart';
import 'package:captain_wrongel/domain/routing/depth_grid.dart';
import 'package:captain_wrongel/domain/routing/navigation_layers_depth_grid.dart';
import 'package:captain_wrongel/features/map/shallow_highlight_layer.dart';
import 'package:flutter_test/flutter_test.dart';

DepthGrid _sampleGrid() {
  return DepthGrid(
    rows: 2,
    cols: 2,
    depthM: [
      [10.0, 3.0],
      [2.0, double.nan],
    ],
    originLatDeg: 36.35,
    originLonDeg: 27.80,
    latStepDeg: 0.0125,
    lonStepDeg: 0.025,
  );
}

void main() {
  group('isShallowDepth', () {
    test('flags missing and shallow depths', () {
      expect(isShallowDepth(2.0, 3.5), isTrue);
      expect(isShallowDepth(3.0, 3.5), isTrue);
      expect(isShallowDepth(double.nan, 3.5), isTrue);
      expect(isShallowDepth(null, 3.5), isTrue);
      expect(isShallowDepth(10.0, 3.5), isFalse);
    });

    test('returns false when need depth is zero', () {
      expect(isShallowDepth(1.0, 0), isFalse);
      expect(isShallowDepth(null, 0), isFalse);
    });
  });

  group('collectShallowCells', () {
    test('returns cells below draft plus clearance', () {
      final grid = _sampleGrid();
      final shallow = collectShallowCells(grid, 3.5);

      expect(shallow, contains((0, 1)));
      expect(shallow, contains((1, 0)));
      expect(shallow, contains((1, 1)));
      expect(shallow, isNot(contains((0, 0))));
    });

    test('returns empty list when requirement is zero', () {
      expect(collectShallowCells(_sampleGrid(), 0), isEmpty);
    });
  });

  group('shallowCellsToGeoJson', () {
    test('builds polygon features for shallow cells', () {
      final geo = shallowCellsToGeoJson(_sampleGrid(), 3.5);
      final features = geo['features'] as List<dynamic>;

      expect(features, hasLength(3));
      for (final f in features) {
        final feature = f as Map<String, dynamic>;
        expect(feature['geometry']?['type'], 'Polygon');
        final ring =
            (feature['geometry']?['coordinates'] as List<dynamic>).first
                as List<dynamic>;
        expect(ring, hasLength(5));
      }
    });

    test('uses CwPalette.depthShallow for fill color', () {
      expect(kShallowHighlightFillColor, '#FBBF24');
      expect(kShallowHighlightFillColor.toUpperCase(), '#FBBF24');
      expect(CwPalette.depthShallow.toARGB32() & 0xFFFFFF, 0xFBBF24);
    });
  });
}
