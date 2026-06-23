import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';
import '../../../l10n/app_localizations.dart';

/// Collapsed peek height per design-system-spec §6 (map screen).
const double kMapPeekSheetHeight = 120;

/// Draggable range fractions (step-11 acceptance).
const double kMapPeekSheetMinFraction = 0.15;
const double kMapPeekSheetMaxFraction = 0.5;

/// Initial sheet fraction: 120dp peek, but not below [kMapPeekSheetMinFraction].
double mapPeekSheetInitialFraction(BuildContext context) {
  final screenH = MediaQuery.sizeOf(context).height;
  if (screenH <= 0) return kMapPeekSheetMinFraction;
  return (kMapPeekSheetHeight / screenH).clamp(
    kMapPeekSheetMinFraction,
    kMapPeekSheetMaxFraction,
  );
}

/// Persistent map bottom peek: mono coordinates + depth, draggable 15–50% height.
class MapPeekSheet extends StatelessWidget {
  const MapPeekSheet({
    super.key,
    required this.lat,
    required this.lon,
    this.depthMeters,
    this.navAidLabel,
  });

  final double lat;
  final double lon;
  final double? depthMeters;
  final String? navAidLabel;

  @override
  Widget build(BuildContext context) {
    final initial = mapPeekSheetInitialFraction(context);

    return DraggableScrollableSheet(
      key: const Key('map_peek_sheet'),
      initialChildSize: initial,
      minChildSize: kMapPeekSheetMinFraction,
      maxChildSize: kMapPeekSheetMaxFraction,
      snap: true,
      snapSizes: [kMapPeekSheetMinFraction, kMapPeekSheetMaxFraction],
      builder: (context, scrollController) {
        return _MapPeekSheetPanel(
          scrollController: scrollController,
          lat: lat,
          lon: lon,
          depthMeters: depthMeters,
          navAidLabel: navAidLabel,
        );
      },
    );
  }
}

class _MapPeekSheetPanel extends StatelessWidget {
  const _MapPeekSheetPanel({
    required this.scrollController,
    required this.lat,
    required this.lon,
    this.depthMeters,
    this.navAidLabel,
  });

  final ScrollController scrollController;
  final double lat;
  final double lon;
  final double? depthMeters;
  final String? navAidLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;

    return Material(
      color: colors.panelBlue,
      elevation: 8,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(CwRadius.lg)),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(CwSpacing.m, 0, CwSpacing.m, CwSpacing.l),
        children: [
          const _MapSheetDragHandle(),
          MapPeekCoordsRow(lat: lat, lon: lon),
          const SizedBox(height: CwSpacing.xs),
          MapPeekDepthLabel(depthMeters: depthMeters),
          if (navAidLabel != null && navAidLabel!.isNotEmpty) ...[
            const SizedBox(height: CwSpacing.m),
            MapPeekNavAidRow(label: navAidLabel!),
          ],
        ],
      ),
    );
  }
}

/// Shared peek row: mono coords, tap to copy.
class MapPeekCoordsRow extends StatelessWidget {
  const MapPeekCoordsRow({
    super.key,
    required this.lat,
    required this.lon,
  });

  final double lat;
  final double lon;

  Future<void> _copyCoords(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;

    await Clipboard.setData(
      ClipboardData(text: CwTypography.formatCoords(lat, lon)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      button: true,
      label: l10n.mapPeekCoordsSemantic,
      child: InkWell(
        key: const Key('map_peek_coords'),
        onTap: () async {
          await _copyCoords(context);
          if (!context.mounted) return;
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            SnackBar(content: Text(l10n.mapCoordsCopied)),
          );
        },
        borderRadius: BorderRadius.circular(CwRadius.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: CwSpacing.xs),
          child: CwTypography.coords(context, lat, lon),
        ),
      ),
    );
  }
}

/// Depth line under coordinates in peek state.
class MapPeekDepthLabel extends StatelessWidget {
  const MapPeekDepthLabel({super.key, this.depthMeters});

  final double? depthMeters;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final text = depthMeters != null
        ? l10n.mapPeekDepthMeters(depthMeters!.round())
        : l10n.mapLongPressDepthUnavailable;

    return Text(
      text,
      key: const Key('map_peek_depth'),
      style: CwTypography.caption(color: colors.textMuted),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class MapPeekNavAidRow extends StatelessWidget {
  const MapPeekNavAidRow({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.mapLongPressNavAid,
          style: CwTypography.caption(color: colors.textMuted),
        ),
        const SizedBox(height: CwSpacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
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
          key: const Key('map_peek_drag_handle'),
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
