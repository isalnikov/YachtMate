import 'package:flutter/material.dart';

import 'widgets/map_context_sheet.dart';

/// Shows the long-press map context sheet (coords, depth, actions).
Future<void> showMapLongPressSheet({
  required BuildContext context,
  required double lat,
  required double lon,
  double? depthMeters,
  String? navAidLabel,
  required VoidCallback onAddWaypoint,
  VoidCallback? onNavigateHere,
}) {
  return showMapContextSheet(
    context: context,
    lat: lat,
    lon: lon,
    depthMeters: depthMeters,
    navAidLabel: navAidLabel,
    onAddWaypoint: onAddWaypoint,
    onNavigateHere: onNavigateHere,
  );
}
