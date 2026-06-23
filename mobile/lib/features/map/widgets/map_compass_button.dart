import 'dart:math' show pi;

import 'package:flutter/material.dart';

import '../../../core/theme/cw_tokens.dart';
import '../../../widgets/cw_button.dart';
import '../../../widgets/cw_button_sizes.dart';

/// North-up / heading-up toggle with optional map-bearing indicator.
class MapCompassButton extends StatelessWidget {
  const MapCompassButton({
    super.key,
    required this.headingUp,
    required this.mapBearing,
    required this.onToggle,
    required this.northUpLabel,
    required this.headingUpLabel,
    this.fabSize = CwFabSize.sm,
    this.enabled = true,
  });

  final bool headingUp;
  final double mapBearing;
  final VoidCallback? onToggle;
  final String northUpLabel;
  final String headingUpLabel;
  final CwFabSize fabSize;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final label = headingUp ? headingUpLabel : northUpLabel;
    final icon = headingUp ? Icons.navigation : Icons.explore;
    final bearingRad = -mapBearing * pi / 180;

    return Transform.rotate(
      angle: headingUp ? 0 : bearingRad,
      child: CwFab(
        icon: icon,
        size: fabSize,
        semanticLabel: label,
        onPressed: enabled ? onToggle : null,
      ),
    );
  }
}
