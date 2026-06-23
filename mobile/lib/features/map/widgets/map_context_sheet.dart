import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_list_tile.dart';
import 'map_peek_sheet.dart';

/// Long-press context sheet: peek coords + expanded action list.
Future<void> showMapContextSheet({
  required BuildContext context,
  required double lat,
  required double lon,
  double? depthMeters,
  String? navAidLabel,
  required VoidCallback onAddWaypoint,
  VoidCallback? onNavigateHere,
}) async {
  final l10n = AppLocalizations.of(context);
  if (l10n == null) return;

  final colors = Theme.of(context).extension<CwColors>() ?? CwColors.light;
  final initial = mapPeekSheetInitialFraction(context);

  await HapticFeedback.mediumImpact();
  if (!context.mounted) return;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: colors.panelBlue,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(CwRadius.lg)),
    ),
    builder: (ctx) {
      return DraggableScrollableSheet(
        key: const Key('map_context_sheet'),
        expand: false,
        initialChildSize: initial,
        minChildSize: kMapPeekSheetMinFraction,
        maxChildSize: kMapPeekSheetMaxFraction,
        snap: true,
        snapSizes: const [kMapPeekSheetMinFraction, kMapPeekSheetMaxFraction],
        builder: (context, scrollController) {
          return _MapContextSheetBody(
            scrollController: scrollController,
            lat: lat,
            lon: lon,
            depthMeters: depthMeters,
            navAidLabel: navAidLabel,
            onAddWaypoint: onAddWaypoint,
            onNavigateHere: onNavigateHere,
          );
        },
      );
    },
  );
}

class _MapContextSheetBody extends StatelessWidget {
  const _MapContextSheetBody({
    required this.scrollController,
    required this.lat,
    required this.lon,
    this.depthMeters,
    this.navAidLabel,
    required this.onAddWaypoint,
    this.onNavigateHere,
  });

  final ScrollController scrollController;
  final double lat;
  final double lon;
  final double? depthMeters;
  final String? navAidLabel;
  final VoidCallback onAddWaypoint;
  final VoidCallback? onNavigateHere;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final navText = (navAidLabel != null && navAidLabel!.isNotEmpty)
        ? navAidLabel!
        : l10n.mapLongPressNavUnavailable;

    return Material(
      color: colors.panelBlue,
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(CwSpacing.m, 0, CwSpacing.m, CwSpacing.l),
        children: [
          const _MapSheetDragHandle(),
          Text(
            l10n.mapLongPressTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: CwSpacing.s),
          MapPeekCoordsRow(lat: lat, lon: lon),
          const SizedBox(height: CwSpacing.xs),
          MapPeekDepthLabel(depthMeters: depthMeters),
          const SizedBox(height: CwSpacing.m),
          const Divider(height: 1),
          const SizedBox(height: CwSpacing.s),
          CwListTile(
            key: const Key('map_context_add_waypoint'),
            title: l10n.mapLongPressAddWaypoint,
            leading: const Icon(Icons.add_location_alt_outlined),
            onTap: () {
              Navigator.of(context).pop();
              onAddWaypoint();
            },
          ),
          CwListTile(
            key: const Key('map_context_navigate_here'),
            title: l10n.mapNavigateHere,
            leading: const Icon(Icons.navigation_outlined),
            onTap: () {
              Navigator.of(context).pop();
              onNavigateHere?.call();
            },
          ),
          CwListTile(
            title: l10n.mapLongPressNavAid,
            subtitle: navText,
            leading: const Icon(Icons.flag_outlined),
            trailing: null,
          ),
        ],
      ),
    );
  }
}

class _MapSheetDragHandle extends StatelessWidget {
  const _MapSheetDragHandle();

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;

    return Center(
      child: Semantics(
        label: 'Drag handle',
        child: Container(
          margin: const EdgeInsets.only(top: CwSpacing.s, bottom: CwSpacing.s),
          width: 32,
          height: 4,
          decoration: BoxDecoration(
            color: colors.textMuted.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(CwRadius.full),
          ),
        ),
      ),
    );
  }
}
