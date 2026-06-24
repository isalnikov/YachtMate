import 'package:captain_wrongel/features/map/offline_chart_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

void main() {
  test('formatOfflineChartStorageLabel reads bytes checksum', () {
    expect(
      formatOfflineChartStorageLabel(
        path: 'sqlite:1',
        checksum: offlineBytesChecksum(1_500_000),
      ),
      '1.4 MB',
    );
  });

  test('estimateOfflinePackBytes returns positive estimate', () {
    final bytes = estimateOfflinePackBytes(
      LatLngBounds(
        southwest: const LatLng(36.0, 28.0),
        northeast: const LatLng(36.5, 28.5),
      ),
      minZoom: 0,
      maxZoom: 10,
    );
    expect(bytes, greaterThan(10_000));
  });
}
