import 'dart:math' show cos, log, pi, pow, tan;

import 'package:maplibre_gl/maplibre_gl.dart';

/// Rough tile-pack size estimate for offline chart downloads (step 66).
int estimateOfflinePackBytes(
  LatLngBounds bounds, {
  required double minZoom,
  required double maxZoom,
  int bytesPerTile = 14_000,
}) {
  var totalTiles = 0.0;
  for (var z = minZoom; z <= maxZoom; z++) {
    final n = pow(2, z).toDouble();
    final latSpan = (bounds.northeast.latitude - bounds.southwest.latitude)
        .abs()
        .clamp(0.001, 180.0);
    final lonSpan = (bounds.northeast.longitude - bounds.southwest.longitude)
        .abs()
        .clamp(0.001, 360.0);

    final x0 = _lonToTileX(bounds.southwest.longitude, n);
    final x1 = _lonToTileX(bounds.northeast.longitude, n);
    final y0 = _latToTileY(bounds.northeast.latitude, n);
    final y1 = _latToTileY(bounds.southwest.latitude, n);

    final tilesX = (x1 - x0).abs().clamp(1, n);
    final tilesY = (y1 - y0).abs().clamp(1, n);
    totalTiles += tilesX * tilesY * (latSpan / 180) * (lonSpan / 360);
  }
  return (totalTiles * bytesPerTile).round().clamp(bytesPerTile, 512 * 1024 * 1024);
}

double _lonToTileX(double lon, double n) => (lon + 180) / 360 * n;

double _latToTileY(double lat, double n) {
  final latRad = lat * pi / 180;
  return (1 - log(tan(latRad) + 1 / cos(latRad)) / pi) / 2 * n;
}

const offlineBytesChecksumPrefix = 'bytes:';

/// Formats storage label from Drift checksum (`bytes:<n>`) or path fallback.
String formatOfflineChartStorageLabel({
  required String path,
  String? checksum,
}) {
  if (checksum != null && checksum.startsWith(offlineBytesChecksumPrefix)) {
    final raw = int.tryParse(checksum.substring(offlineBytesChecksumPrefix.length));
    if (raw != null) return _formatBytes(raw);
  }
  if (path.startsWith('sqlite:')) return '—';
  return '—';
}

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(1)} KB';
  }
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

String offlineBytesChecksum(int bytes) => '$offlineBytesChecksumPrefix$bytes';
