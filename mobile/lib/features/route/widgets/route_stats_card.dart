import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_card.dart';
import '../route_planning_helpers.dart';

/// Distance, ETA, and waypoint count for the active draft route.
class RouteStatsCard extends StatelessWidget {
  const RouteStatsCard({
    super.key,
    required this.waypoints,
    this.speedKn = kRoutePlanningSpeedKn,
  });

  final List<({double lat, double lon})> waypoints;
  final double speedKn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final distanceNm = routeDistanceNm(waypoints);
    final etaHours = routeEtaHours(distanceNm, speedKn: speedKn);

    return CwCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.routeStatsTitle,
            style: CwTypography.h2(color: colors.textPrimary),
          ),
          const SizedBox(height: CwSpacing.m),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: l10n.routeStatsDistance,
                  value: l10n.routeStatsDistanceValue(distanceNm.toStringAsFixed(1)),
                ),
              ),
              Expanded(
                child: _StatTile(
                  label: l10n.routeStatsEta,
                  value: _formatEta(l10n, etaHours),
                ),
              ),
              Expanded(
                child: _StatTile(
                  label: l10n.routeStatsWaypointCount,
                  value: l10n.routeStatsWaypointCountValue(waypoints.length),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatEta(AppLocalizations l10n, double? etaHours) {
    if (etaHours == null) return l10n.routeStatsEtaUnknown;
    if (etaHours < 1) {
      final minutes = (etaHours * 60).round();
      return l10n.routeStatsEtaMinutes(minutes);
    }
    final h = etaHours.floor();
    final m = ((etaHours - h) * 60).round();
    if (m == 0) return l10n.routeStatsEtaHours(h);
    return l10n.routeStatsEtaHoursMinutes(h, m);
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: CwTypography.caption(color: colors.textMuted),
        ),
        const SizedBox(height: CwSpacing.xs),
        Text(
          value,
          style: CwTypography.h2(color: colors.accentTeal),
        ),
      ],
    );
  }
}
