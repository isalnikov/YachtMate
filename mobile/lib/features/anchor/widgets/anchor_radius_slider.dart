import 'package:flutter/material.dart';

import '../../../core/theme/cw_tokens.dart';
import '../../../l10n/app_localizations.dart';

/// Radius editor: 20–200 m with live label.
class AnchorRadiusSlider extends StatelessWidget {
  const AnchorRadiusSlider({
    super.key,
    required this.radiusM,
    required this.onChanged,
    this.enabled = true,
  });

  static const minRadiusM = 20.0;
  static const maxRadiusM = 200.0;

  final double radiusM;
  final ValueChanged<double> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final value = radiusM.clamp(minRadiusM, maxRadiusM);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${l10n.anchorWatchRadius}: ${value.toStringAsFixed(0)} m',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: CwSpacing.xs),
        Slider(
          min: minRadiusM,
          max: maxRadiusM,
          divisions: 18,
          label: '${value.toStringAsFixed(0)} m',
          value: value,
          onChanged: enabled ? onChanged : null,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${minRadiusM.toStringAsFixed(0)} m',
              style: theme.textTheme.bodySmall,
            ),
            Text(
              '${maxRadiusM.toStringAsFixed(0)} m',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
