import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/energy_profile_controller.dart';
import '../../../core/providers.dart';
import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../map_gps_status_provider.dart';
import 'gps_fix_indicator.dart';

/// Status pill height per design-system-spec §6.
const double kMapStatusPillHeight = 32;

/// Top inset below safe area (design-system-spec §6).
const double kMapStatusPillTopInset = 8;

/// Glanceable GPS status pill — top center of the map screen (step-22).
class MapStatusPill extends ConsumerWidget {
  const MapStatusPill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(mapGpsStatusProvider);
    final eco = ref.watch(energyProfileProvider) == EnergyProfile.eco;
    final top = MediaQuery.paddingOf(context).top + kMapStatusPillTopInset;

    return Positioned(
      top: top,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.topCenter,
        child: MapStatusPillView(
          status: status,
          ecoMode: eco,
          onTap: () => _onTap(context, status.fixStatus),
        ),
      ),
    );
  }

  Future<void> _onTap(BuildContext context, GpsFixStatus fixStatus) async {
    final l10n = AppLocalizations.of(context)!;
    if (fixStatus == GpsFixStatus.denied) {
      await Geolocator.openAppSettings();
    } else {
      await Geolocator.openLocationSettings();
    }
    if (!context.mounted) return;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(l10n.mapGpsLocationSettingsHint)),
    );
  }
}

/// Pure view for [MapStatusPill] — testable without GPS stream.
class MapStatusPillView extends StatelessWidget {
  const MapStatusPillView({
    super.key,
    required this.status,
    required this.ecoMode,
    this.onTap,
  });

  final MapGpsStatus status;
  final bool ecoMode;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final caption = CwTypography.caption(color: colors.textPrimary);

    final parts = <Widget>[
      GpsFixIndicator(status: status.fixStatus),
      if (status.accuracyM != null && status.fixStatus == GpsFixStatus.fix)
        Text(
          l10n.mapGpsAccuracyMeters(status.accuracyM!.round()),
          key: const Key('map_status_accuracy'),
          style: caption,
        ),
      if (status.sogKnots != null)
        Text(
          l10n.mapGpsSogKnots(status.sogKnots!.toStringAsFixed(1)),
          key: const Key('map_status_sog'),
          style: caption,
        ),
      if (ecoMode)
        Icon(
          Icons.energy_savings_leaf_outlined,
          key: const Key('map_status_eco'),
          size: 16,
          color: colors.accentTeal,
          semanticLabel: l10n.energyProfileEco,
        ),
    ];

    return Semantics(
      button: true,
      label: l10n.mapGpsStatusSemantic,
      child: Material(
        color: colors.panelBlue.withValues(alpha: 0.88),
        elevation: 2,
        borderRadius: BorderRadius.circular(CwRadius.full),
        child: InkWell(
          key: const Key('map_status_pill'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(CwRadius.full),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: kMapStatusPillHeight),
            child: Padding(
              key: const Key('map_status_pill_padding'),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < parts.length; i++) ...[
                    if (i > 0) const SizedBox(width: CwSpacing.s),
                    parts[i],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
