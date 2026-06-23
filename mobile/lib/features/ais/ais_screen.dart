import 'dart:async' show unawaited;
import 'dart:math' show Point;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../domain/ais/ais_target.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_card.dart';
import '../map/chart_engine_platform.dart';
import 'ais_demo_provider.dart';
import 'ais_filter_provider.dart';
import 'ais_nmea_preferences.dart';
import 'ais_targets_provider.dart';
import 'widgets/ais_filter_bar.dart';
import 'widgets/ais_vessel_marker.dart';
import 'widgets/ais_vessel_sheet.dart';

/// Full-screen AIS traffic view from More menu (Step 20).
class AisScreen extends ConsumerStatefulWidget {
  const AisScreen({super.key});

  @override
  ConsumerState<AisScreen> createState() => _AisScreenState();
}

class _AisScreenState extends ConsumerState<AisScreen> {
  static const _initial = CameraPosition(
    target: LatLng(36.65, 29.12),
    zoom: 10,
  );

  MapLibreMapController? _controller;
  bool _layersReady = false;
  late final TextEditingController _hostController;
  late final TextEditingController _portController;

  @override
  void initState() {
    super.initState();
    _hostController = TextEditingController();
    _portController = TextEditingController();
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bridge = ref.watch(aisNmeaBridgeProvider);
    final endpoint = ref.watch(aisNmeaPreferencesProvider);
    if (_hostController.text != endpoint.host) {
      _hostController.text = endpoint.host;
    }
    if (_portController.text != '${endpoint.port}') {
      _portController.text = '${endpoint.port}';
    }
    final filter = ref.watch(aisFilterProvider);
    final targets = ref.watch(aisTargetsProvider);
    final visible = filterAisTargets(targets, filter).toList()
      ..sort((AisTarget a, AisTarget b) => a.mmsi.compareTo(b.mmsi));

    ref.listen(aisTargetsProvider, (prev, next) {
      final c = _controller;
      if (c != null && _layersReady) {
        unawaited(updateAisVesselLayers(c, next, ref.read(aisFilterProvider)));
      }
    });

    ref.listen(aisFilterProvider, (prev, next) {
      final c = _controller;
      if (c != null && _layersReady) {
        unawaited(
          updateAisVesselLayers(c, ref.read(aisTargetsProvider), next),
        );
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AisFilterBar(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: CwCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  dense: true,
                  leading: Icon(
                    bridge.isActive ? Icons.sensors : Icons.sensors_off_outlined,
                    color: bridge.isActive
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  title: Text(l10n.aisLocalStreamTitle),
                  subtitle: Text(_streamSubtitle(l10n, bridge)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: SegmentedButton<AisNmeaSourceMode>(
                    segments: [
                      ButtonSegment(
                        value: AisNmeaSourceMode.off,
                        label: Text(l10n.aisSourceOff),
                      ),
                      ButtonSegment(
                        value: AisNmeaSourceMode.demo,
                        label: Text(l10n.aisSourceDemo),
                      ),
                      ButtonSegment(
                        value: AisNmeaSourceMode.live,
                        label: Text(l10n.aisSourceLive),
                      ),
                    ],
                    selected: {bridge.mode},
                    onSelectionChanged: (set) => unawaited(
                      ref
                          .read(aisNmeaBridgeProvider.notifier)
                          .setMode(set.single),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: l10n.aisNmeaHost,
                            hintText: l10n.aisNmeaHostHint,
                            isDense: true,
                          ),
                          controller: _hostController,
                          onSubmitted: (v) => unawaited(
                            ref
                                .read(aisNmeaPreferencesProvider.notifier)
                                .setHost(v),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: l10n.aisNmeaPort,
                            hintText: l10n.aisNmeaPortHint,
                            isDense: true,
                          ),
                          keyboardType: TextInputType.number,
                          controller: _portController,
                          onSubmitted: (v) {
                            final port = int.tryParse(v.trim());
                            if (port != null) {
                              unawaited(
                                ref
                                    .read(aisNmeaPreferencesProvider.notifier)
                                    .setPort(port),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Text(
            l10n.aisTargetsCount(visible.length),
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        Expanded(
          child: chartEngineSupported()
              ? _AisMap(
                  initial: _initial,
                  onController: (c) => _controller = c,
                  onLayersReady: () {
                    if (mounted) setState(() => _layersReady = true);
                  },
                  onVesselTap: (mmsi) => _openVessel(context, targets[mmsi]),
                )
              : _AisTargetList(
                  targets: visible,
                  onTap: (t) => unawaited(showAisVesselSheet(
                    context: context,
                    target: t,
                  )),
                ),
        ),
      ],
    );
  }

  Future<void> _openVessel(BuildContext context, AisTarget? target) async {
    if (target == null || !context.mounted) return;
    await showAisVesselSheet(context: context, target: target);
  }

  String _streamSubtitle(AppLocalizations l10n, AisNmeaBridgeState bridge) {
    return switch (bridge.mode) {
      AisNmeaSourceMode.demo => l10n.aisDemoActive,
      AisNmeaSourceMode.live when bridge.liveConnected => l10n.aisLiveActive,
      AisNmeaSourceMode.live => l10n.aisLiveConnecting,
      AisNmeaSourceMode.off => l10n.aisLocalStreamBody,
    };
  }
}

class _AisMap extends ConsumerStatefulWidget {
  const _AisMap({
    required this.initial,
    required this.onController,
    required this.onLayersReady,
    required this.onVesselTap,
  });

  final CameraPosition initial;
  final ValueChanged<MapLibreMapController> onController;
  final VoidCallback onLayersReady;
  final ValueChanged<int> onVesselTap;

  @override
  ConsumerState<_AisMap> createState() => _AisMapState();
}

class _AisMapState extends ConsumerState<_AisMap> {
  MapLibreMapController? _controller;
  bool _styleLoaded = false;

  Future<void> _onStyleLoaded() async {
    final c = _controller;
    if (c == null) return;
    await installAisVesselLayers(c);
    await updateAisVesselLayers(
      c,
      ref.read(aisTargetsProvider),
      ref.read(aisFilterProvider),
    );
    widget.onLayersReady();
    if (mounted) setState(() => _styleLoaded = true);
  }

  Future<void> _handleTap(Point<double> screen) async {
    final c = _controller;
    if (c == null) return;
    try {
      final hits = await c.queryRenderedFeatures(screen, [
        cwAisVesselHitLayerId,
        cwAisVesselFillLayerId,
      ], null);
      if (!mounted) return;
      for (final hit in hits) {
        if (hit is! Map) continue;
        final props = hit['properties'];
        if (props is! Map) continue;
        final mmsi = props['mmsi'];
        if (mmsi is int) {
          widget.onVesselTap(mmsi);
          return;
        }
        if (mmsi is num) {
          widget.onVesselTap(mmsi.toInt());
          return;
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        MapLibreMap(
          initialCameraPosition: widget.initial,
          compassEnabled: false,
          onMapCreated: (c) {
            _controller = c;
            widget.onController(c);
          },
          onStyleLoadedCallback: () => unawaited(_onStyleLoaded()),
          onMapClick: (screen, _) => unawaited(_handleTap(screen)),
        ),
        if (!_styleLoaded)
          const Positioned.fill(
            child: ColoredBox(
              color: Colors.black26,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        Positioned(
          left: 12,
          right: 12,
          bottom: 12,
          child: Material(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                l10n.aisTapVessel,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AisTargetList extends StatelessWidget {
  const _AisTargetList({
    required this.targets,
    required this.onTap,
  });

  final List<AisTarget> targets;
  final ValueChanged<AisTarget> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (targets.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.aisTapVessel,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: targets.length,
      itemBuilder: (ctx, i) {
        final t = targets[i];
        return Card(
          child: ListTile(
            title: Text(t.displayName),
            subtitle: Text(
              'MMSI ${t.mmsi} · ${t.sogKnots.toStringAsFixed(1)} kn · '
              '${t.cogDegrees.toStringAsFixed(0)}°',
            ),
            onTap: () => onTap(t),
          ),
        );
      },
    );
  }
}
