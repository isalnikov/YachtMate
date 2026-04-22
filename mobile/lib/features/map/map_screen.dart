import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../l10n/app_localizations.dart';
import 'chart_engine_platform.dart';

/// MapLibre base chart (Фаза 1.1). Annotations / GPS sync in later hooks.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initial = CameraPosition(target: LatLng(59.94, 30.32), zoom: 9);

  bool _styleLoaded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!chartEngineSupported()) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.mapUnavailableOnPlatform,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Stack(
      children: [
        MapLibreMap(
          initialCameraPosition: _initial,
          trackCameraPosition: true,
          onMapCreated: (_) {},
          onStyleLoadedCallback: () {
            if (mounted) setState(() => _styleLoaded = true);
          },
        ),
        if (!_styleLoaded)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black26,
              child: Center(child: Text(l10n.mapLoadingStyle)),
            ),
          ),
      ],
    );
  }

}
