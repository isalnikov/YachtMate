import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/map/demo_navigation_layers_index.dart';
import '../map/map_navigation_asset.dart';

/// Тот же GeoJSON, что подгружается для слоёв карты — [kNavigationLayersGeoJsonAsset].
final demoNavigationLayersIndexProvider =
    FutureProvider<DemoNavigationLayersIndex>((ref) async {
      final raw = await rootBundle.loadString(kNavigationLayersGeoJsonAsset);
      final root = jsonDecode(raw) as Map<String, dynamic>;
      return DemoNavigationLayersIndex.fromGeoJson(root);
    });
