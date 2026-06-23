import 'package:maplibre_gl/maplibre_gl.dart';

import 'map_layer_kinds.dart';

/// MapLibre source/layer ids for the optional raster overlay.
const cwMapOverlaySourceId = 'cw_map_overlay_raster';
const cwMapOverlayLayerId = 'cw_map_overlay_raster_layer';

/// Tile template and raster paint for one [MapOverlayKind].
class MapOverlayTileConfig {
  const MapOverlayTileConfig({
    required this.tiles,
    this.attribution,
    this.rasterOpacity = 1.0,
    this.maxzoom = 19,
    this.tileSize = 256,
  });

  final List<String> tiles;
  final String? attribution;
  final double rasterOpacity;
  final double maxzoom;
  final double tileSize;

  bool get isValid => tiles.isNotEmpty && tiles.every((t) => t.trim().isNotEmpty);
}

/// Resolves overlay kind to a free raster template (no Navionics / SonarChart HD).
MapOverlayTileConfig? overlayTileConfigFor(MapOverlayKind kind) {
  switch (kind) {
    case MapOverlayKind.none:
      return null;
    case MapOverlayKind.satellite:
      return const MapOverlayTileConfig(
        tiles: [
          'https://server.arcgisonline.com/ArcGIS/rest/services/'
          'World_Imagery/MapServer/tile/{z}/{y}/{x}',
        ],
        attribution: 'Esri, Maxar, Earthstar Geographics',
        maxzoom: 19,
      );
    case MapOverlayKind.reliefShading:
      return const MapOverlayTileConfig(
        tiles: [
          'https://server.arcgisonline.com/ArcGIS/rest/services/Elevation/'
          'World_Hillshade/MapServer/tile/{z}/{y}/{x}',
        ],
        attribution: 'Esri',
        rasterOpacity: 0.85,
        maxzoom: 15,
      );
    case MapOverlayKind.sonar:
      return const MapOverlayTileConfig(
        tiles: [
          'https://server.arcgisonline.com/ArcGIS/rest/services/Ocean/'
          'World_Ocean_Reference/MapServer/tile/{z}/{y}/{x}',
        ],
        attribution: 'Esri (SonarChart placeholder)',
        rasterOpacity: 0.45,
        maxzoom: 13,
      );
  }
}

/// Removes the raster overlay source/layer if present.
Future<void> removeMapTileOverlay(MapLibreMapController controller) async {
  try {
    await controller.removeLayer(cwMapOverlayLayerId);
  } catch (_) {}
  try {
    await controller.removeSource(cwMapOverlaySourceId);
  } catch (_) {}
}

/// Applies [kind] as a raster layer, or clears overlay when [none] / invalid URL.
///
/// [belowLayerId] keeps vector annotations above the raster when re-applying.
Future<bool> applyMapTileOverlay(
  MapLibreMapController controller,
  MapOverlayKind kind, {
  String? belowLayerId,
}) async {
  await removeMapTileOverlay(controller);

  final config = overlayTileConfigFor(kind);
  if (config == null || !config.isValid) {
    return kind == MapOverlayKind.none;
  }

  try {
    await controller.addSource(
      cwMapOverlaySourceId,
      RasterSourceProperties(
        tiles: config.tiles,
        tileSize: config.tileSize,
        maxzoom: config.maxzoom,
        attribution: config.attribution,
      ),
    );

    await controller.addRasterLayer(
      cwMapOverlaySourceId,
      cwMapOverlayLayerId,
      RasterLayerProperties(
        rasterOpacity: config.rasterOpacity,
        visibility: 'visible',
      ),
      belowLayerId: belowLayerId,
    );
    return true;
  } catch (_) {
    await removeMapTileOverlay(controller);
    return false;
  }
}
