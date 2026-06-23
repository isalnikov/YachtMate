import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/cw_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_bottom_sheet.dart';
import '../../widgets/cw_section_header.dart';
import 'map_layer_kinds.dart';
import 'widgets/layer_thumbnail_grid.dart';

Future<void> showMapLayerSheet(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  if (l10n == null) return;

  await showCwBottomSheet(
    context: context,
    title: l10n.mapLayersSheetTitle,
    child: const MapLayerSheetContent(),
  );
}

class MapLayerSheetContent extends ConsumerWidget {
  const MapLayerSheetContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final vis = ref.watch(mapLayerPreferencesProvider);
    final notifier = ref.read(mapLayerPreferencesProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CwSectionHeader(label: l10n.mapLayerSectionOverlays),
        LayerThumbnailGrid(
          selectedId: vis.overlay.name,
          onSelected: (id) => notifier.setOverlay(
            MapOverlayKind.values.firstWhere((e) => e.name == id),
          ),
          options: [
            LayerThumbnailOption(
              id: MapOverlayKind.none.name,
              label: l10n.mapLayerOverlayNone,
              thumbnail: _overlayThumbnail(
                const [CwPalette.panelBlue, CwPalette.deckBlue],
              ),
            ),
            LayerThumbnailOption(
              id: MapOverlayKind.satellite.name,
              label: l10n.mapLayerOverlaySatellite,
              thumbnail: _overlayThumbnail(
                const [Color(0xFF1B4332), Color(0xFF40916C)],
                icon: Icons.satellite_alt,
              ),
            ),
            LayerThumbnailOption(
              id: MapOverlayKind.reliefShading.name,
              label: l10n.mapLayerOverlayRelief,
              thumbnail: _overlayThumbnail(
                const [Color(0xFF0E4D64), Color(0xFF48CAE4)],
                icon: Icons.terrain,
              ),
            ),
            LayerThumbnailOption(
              id: MapOverlayKind.sonar.name,
              label: l10n.mapLayerOverlaySonar,
              thumbnail: _overlayThumbnail(
                const [Color(0xFF023E8A), Color(0xFF90E0EF)],
                icon: Icons.waves,
              ),
            ),
          ],
        ),
        CwSectionHeader(label: l10n.mapLayerSectionChart),
        LayerThumbnailGrid(
          selectedId: vis.chartStyle.name,
          onSelected: (id) => notifier.setChartStyle(
            ChartStyleKind.values.firstWhere((e) => e.name == id),
          ),
          options: [
            LayerThumbnailOption(
              id: ChartStyleKind.standard.name,
              label: l10n.mapLayerChartStandard,
              thumbnail: _chartThumbnail(const [
                Color(0xFF1D3557),
                Color(0xFF457B9D),
              ]),
            ),
            LayerThumbnailOption(
              id: ChartStyleKind.paper.name,
              label: l10n.mapLayerChartPaper,
              thumbnail: _chartThumbnail(const [
                Color(0xFFF5E6C8),
                Color(0xFFD4A574),
              ]),
            ),
            LayerThumbnailOption(
              id: ChartStyleKind.simple.name,
              label: l10n.mapLayerChartSimple,
              thumbnail: _chartThumbnail(const [
                Color(0xFF2B2D42),
                Color(0xFF8D99AE),
              ]),
            ),
            LayerThumbnailOption(
              id: ChartStyleKind.night.name,
              label: l10n.mapLayerChartNight,
              thumbnail: _chartThumbnail(const [
                Color(0xFF1A0000),
                Color(0xFF4A0000),
              ]),
            ),
          ],
        ),
        CwSectionHeader(label: l10n.mapLayerSectionShallow),
        SwitchListTile(
          key: const Key('map_layer_shallow_highlight'),
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.mapLayerShallowHighlight),
          value: vis.shallowHighlight,
          onChanged: notifier.setShallowHighlight,
        ),
      ],
    );
  }
}

Widget _overlayThumbnail(List<Color> gradient, {IconData? icon}) {
  return DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradient,
      ),
    ),
    child: icon == null
        ? null
        : Center(
            child: Icon(icon, color: Colors.white.withValues(alpha: 0.85), size: 28),
          ),
  );
}

Widget _chartThumbnail(List<Color> gradient) {
  return DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: gradient,
      ),
    ),
    child: CustomPaint(
      painter: _ChartLinesPainter(gradient.last.withValues(alpha: 0.6)),
      size: Size.infinite,
    ),
  );
}

class _ChartLinesPainter extends CustomPainter {
  _ChartLinesPainter(this.lineColor);

  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;

    for (var i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.7, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ChartLinesPainter oldDelegate) =>
      oldDelegate.lineColor != lineColor;
}
