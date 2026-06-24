import 'package:maplibre_gl/maplibre_gl.dart';

/// Path prefix for MapLibre offline packs saved from the map download FAB.
final offlineChartSqlitePackPath = RegExp(r'^sqlite:(\d+)$');

/// Deletes MapLibre offline tile packs referenced by chart region paths (step 63).
abstract class OfflineChartPackDeleter {
  Future<void> deletePackAtPath(String path);
}

/// Parses `sqlite:<packId>` paths written by [_cacheVisibleRegion].
class MapLibreOfflineChartPackDeleter implements OfflineChartPackDeleter {
  const MapLibreOfflineChartPackDeleter();

  @override
  Future<void> deletePackAtPath(String path) async {
    final match = offlineChartSqlitePackPath.firstMatch(path);
    if (match == null) return;
    await deleteOfflineRegion(int.parse(match.group(1)!));
  }
}

/// No-op for unit tests and legacy region paths.
class NoOpOfflineChartPackDeleter implements OfflineChartPackDeleter {
  const NoOpOfflineChartPackDeleter();

  @override
  Future<void> deletePackAtPath(String path) async {}
}
