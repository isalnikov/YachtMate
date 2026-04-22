import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';

Future<void> showMapLongPressSheet({
  required BuildContext context,
  required double lat,
  required double lon,
  double? depthMeters,
  String? navAidLabel,
  required VoidCallback onAddWaypoint,
}) async {
  final l10n = AppLocalizations.of(context);
  if (l10n == null) return;

  final coordFmt = NumberFormat('##0.00000', 'en_US');

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      final depthText = depthMeters != null
          ? '${depthMeters.round()} m'
          : l10n.mapLongPressDepthUnavailable;
      final navText =
          (navAidLabel != null && navAidLabel.isNotEmpty)
              ? navAidLabel
              : l10n.mapLongPressNavUnavailable;

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.mapLongPressTitle,
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.mapLongPressLatitude),
                subtitle: Text(coordFmt.format(lat)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.mapLongPressLongitude),
                subtitle: Text(coordFmt.format(lon)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.mapLongPressDepth),
                subtitle: Text(depthText),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.mapLongPressNavAid),
                subtitle: Text(navText),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  onAddWaypoint();
                },
                child: Text(l10n.mapLongPressAddWaypoint),
              ),
            ],
          ),
        ),
      );
    },
  );
}
