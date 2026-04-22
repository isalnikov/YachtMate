import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/map/demo_navigation_layers_index.dart';

/// Тот же GeoJSON, что подгружается для демо-слоёв карты (`demo_navigation_layers.geojson`).
final demoNavigationLayersIndexProvider =
    FutureProvider<DemoNavigationLayersIndex>((ref) async {
      final raw = await rootBundle.loadString(
        'assets/map/demo_navigation_layers.geojson',
      );
      final root = jsonDecode(raw) as Map<String, dynamic>;
      return DemoNavigationLayersIndex.fromGeoJson(root);
    });
