import 'package:flutter/material.dart';

import '../../../core/theme/cw_tokens.dart';
import '../../../widgets/cw_button.dart';
import '../../../widgets/cw_button_sizes.dart';

/// Stacked zoom +/- FABs (Navionics-style).
class MapZoomButtons extends StatelessWidget {
  const MapZoomButtons({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.zoomInLabel,
    required this.zoomOutLabel,
    this.fabSize = CwFabSize.sm,
    this.enabled = true,
  });

  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final String zoomInLabel;
  final String zoomOutLabel;
  final CwFabSize fabSize;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final onIn = enabled ? onZoomIn : null;
    final onOut = enabled ? onZoomOut : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CwFab(
          icon: Icons.add,
          size: fabSize,
          semanticLabel: zoomInLabel,
          onPressed: onIn,
        ),
        const SizedBox(height: CwSpacing.xs),
        CwFab(
          icon: Icons.remove,
          size: fabSize,
          semanticLabel: zoomOutLabel,
          onPressed: onOut,
        ),
      ],
    );
  }
}
