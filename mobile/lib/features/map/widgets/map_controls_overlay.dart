import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/accessibility_preferences_controller.dart';
import '../../../core/providers.dart';
import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_button.dart';
import '../../../widgets/cw_button_sizes.dart';
import 'map_compass_button.dart';
import 'map_zoom_buttons.dart';

/// Right-side map FAB column: zoom, compass, layers, follow GPS.
class MapControlsOverlay extends ConsumerWidget {
  const MapControlsOverlay({
    super.key,
    required this.enabled,
    required this.headingUp,
    required this.mapBearing,
    required this.followGps,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onCompassToggle,
    required this.onLayers,
    required this.onFollowGpsToggle,
    this.bottomInset = 200,
  });

  final bool enabled;
  final bool headingUp;
  final double mapBearing;
  final bool followGps;
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onCompassToggle;
  final VoidCallback? onLayers;
  final VoidCallback? onFollowGpsToggle;

  /// Keeps the column above bottom-right utility FABs.
  final double bottomInset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final glove = ref.watch(accessibilityPreferencesProvider).gloveMode;
    final fabSize = CwFabSize.fromGloveMode(glove);
    final colors = context.cwColors;

    return Positioned(
      right: 12,
      top: 0,
      bottom: bottomInset,
      child: Align(
        alignment: const Alignment(1, -0.15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MapZoomButtons(
              fabSize: fabSize,
              enabled: enabled,
              zoomInLabel: l10n.mapZoomInTooltip,
              zoomOutLabel: l10n.mapZoomOutTooltip,
              onZoomIn: onZoomIn,
              onZoomOut: onZoomOut,
            ),
            const SizedBox(height: CwSpacing.s),
            MapCompassButton(
              fabSize: fabSize,
              enabled: enabled,
              headingUp: headingUp,
              mapBearing: mapBearing,
              northUpLabel: l10n.mapCompassNorthUpTooltip,
              headingUpLabel: l10n.mapCompassHeadingUpTooltip,
              onToggle: onCompassToggle,
            ),
            const SizedBox(height: CwSpacing.s),
            CwFab(
              icon: Icons.layers_outlined,
              size: fabSize,
              semanticLabel: l10n.mapLayersTooltip,
              onPressed: enabled ? onLayers : null,
            ),
            const SizedBox(height: CwSpacing.s),
            DecoratedBox(
              decoration: followGps
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.accentOrange, width: 2),
                    )
                  : const BoxDecoration(),
              child: CwFab(
                icon: followGps ? Icons.gps_fixed : Icons.gps_not_fixed,
                size: fabSize,
                semanticLabel: followGps
                    ? l10n.mapFollowGpsActiveTooltip
                    : l10n.mapFollowGpsTooltip,
                onPressed: enabled ? onFollowGpsToggle : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
