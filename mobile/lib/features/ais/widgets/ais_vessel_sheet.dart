import 'package:flutter/material.dart';

import '../../../domain/ais/ais_target.dart';
import '../../../domain/ais/cpa_tcpa.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_badge.dart';
import '../ais_own_ship.dart';

Future<void> showAisVesselSheet({
  required BuildContext context,
  required AisTarget target,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => AisVesselSheet(target: target),
  );
}

/// Bottom sheet: name, MMSI, SOG, COG, CPA/TCPA with warning badge.
class AisVesselSheet extends StatelessWidget {
  const AisVesselSheet({super.key, required this.target});

  final AisTarget target;

  static const double _cpaWarningNm = 1.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cpa = computeCpaTcpa(
      ownLatDeg: AisOwnShip.latitudeDeg,
      ownLonDeg: AisOwnShip.longitudeDeg,
      ownCogDeg: AisOwnShip.cogDegrees,
      ownSogKn: AisOwnShip.sogKnots,
      tgtLatDeg: target.latitudeDeg,
      tgtLonDeg: target.longitudeDeg,
      tgtCogDeg: target.cogDegrees,
      tgtSogKn: target.sogKnots,
    );
    final cpaClose = cpa.cpaNm < _cpaWarningNm && cpa.tcpaHours > 0;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.paddingOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  target.displayName,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              if (cpaClose)
                CwBadge(
                  label: l10n.aisCpaWarning,
                  variant: CwBadgeVariant.danger,
                ),
            ],
          ),
          const SizedBox(height: 12),
          _Row(label: 'MMSI', value: '${target.mmsi}'),
          _Row(
            label: 'SOG',
            value: l10n.aisVesselSog(target.sogKnots.toStringAsFixed(1)),
          ),
          _Row(
            label: 'COG',
            value: l10n.aisVesselCog(target.cogDegrees.toStringAsFixed(0)),
          ),
          _Row(
            label: 'CPA',
            value: l10n.aisVesselCpa(cpa.cpaNm.toStringAsFixed(2)),
          ),
          _Row(
            label: 'TCPA',
            value: cpa.tcpaHours.isInfinite
                ? '—'
                : l10n.aisVesselTcpa(
                    (cpa.tcpaHours * 60).toStringAsFixed(0),
                  ),
          ),
          if (target.trueHeadingDeg != null) ...[
            _Row(label: 'HDG', value: '${target.trueHeadingDeg}°'),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
