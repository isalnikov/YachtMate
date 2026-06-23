import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';

/// GPS receiver state for the map status pill (step-22).
enum GpsFixStatus {
  /// Valid position fix.
  fix,

  /// Permission granted but no fix yet.
  searching,

  /// Location permission denied.
  denied,
}

/// Colored dot: green fix / amber searching / red denied.
class GpsFixIndicator extends StatelessWidget {
  const GpsFixIndicator({
    super.key,
    required this.status,
    this.size = 8,
  });

  final GpsFixStatus status;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final color = switch (status) {
      GpsFixStatus.fix => colors.safe,
      GpsFixStatus.searching => colors.accentOrange,
      GpsFixStatus.denied => colors.danger,
    };

    return Semantics(
      label: switch (status) {
        GpsFixStatus.fix => 'GPS fix',
        GpsFixStatus.searching => 'GPS searching',
        GpsFixStatus.denied => 'GPS denied',
      },
      child: Container(
        key: Key('gps_fix_indicator_${status.name}'),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: CwPalette.textPrimary.withValues(alpha: 0.25),
          ),
        ),
      ),
    );
  }
}
