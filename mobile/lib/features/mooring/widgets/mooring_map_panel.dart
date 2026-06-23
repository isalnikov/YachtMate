import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../../data/local/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../map/chart_engine_platform.dart';
import '../../map/mooring_layer.dart';
import '../mooring_list_helpers.dart';

/// Compact map preview for the mooring tab (filtered catalog pins).
class MooringMapPanel extends StatefulWidget {
  const MooringMapPanel({
    super.key,
    required this.places,
    required this.onPlaceTap,
  });

  final List<MooringPlaceRow> places;
  final ValueChanged<MooringPlaceRow> onPlaceTap;

  @override
  State<MooringMapPanel> createState() => _MooringMapPanelState();
}

class _MooringMapPanelState extends State<MooringMapPanel> {
  static const _initial = CameraPosition(
    target: LatLng(kMooringDemoRefLat, kMooringDemoRefLon),
    zoom: 10,
  );

  MapLibreMapController? _controller;
  bool _layerReady = false;

  @override
  void didUpdateWidget(covariant MooringMapPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_layerReady && _controller != null) {
      unawaited(updateMooringPlacesLayer(_controller!, widget.places));
    }
  }

  Future<void> _onStyleLoaded() async {
    final c = _controller;
    if (c == null) return;
    await installMooringPlacesLayer(c);
    await updateMooringPlacesLayer(c, widget.places);
    if (mounted) setState(() => _layerReady = true);
  }

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

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: MapLibreMap(
        initialCameraPosition: _initial,
        compassEnabled: false,
        myLocationEnabled: false,
        onMapCreated: (c) => _controller = c,
        onStyleLoadedCallback: () => unawaited(_onStyleLoaded()),
      ),
    );
  }
}
