import 'dart:async' show unawaited;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/active_route_id.dart';
import '../../core/advisory_disclaimer_gate.dart';
import '../../core/errors/cw_error_catalog.dart';
import '../../core/providers.dart';
import '../../core/ship_routing_preferences.dart';
import '../../core/vessel_prefs.dart';
import '../../core/theme/cw_tokens.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/route_repository.dart';
import '../../domain/map/demo_navigation_layers_index.dart';
import '../../domain/routing/auto_guidance.dart';
import '../../domain/routing/navigation_layers_depth_grid.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_button.dart';
import '../../widgets/cw_card.dart';
import '../../widgets/cw_split_view.dart';
import 'advisory_polyline_notifier.dart';
import 'demo_navigation_layers_index_provider.dart';
import 'route_corridor_preferences.dart';
import 'route_planning_helpers.dart';
import 'widgets/route_map_panel.dart';
import 'widgets/route_stats_card.dart';
import 'widgets/safety_check_banner.dart';
import 'widgets/waypoint_list_panel.dart';

/// Вкладка «Маршрут»: advisory A* по изобатам демо-слоя (Фаза 5 — не ECDIS).
class RouteScreen extends ConsumerStatefulWidget {
  const RouteScreen({super.key});

  @override
  ConsumerState<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends ConsumerState<RouteScreen> {
  late final TextEditingController _draftCtrl;
  late final TextEditingController _clearanceCtrl;
  String? _lastMessage;
  List<RouteWaypointRow> _waypoints = [];

  @override
  void initState() {
    super.initState();
    final vessel = ref.read(vesselPrefsProvider);
    final p = ref.read(shipRoutingPreferencesProvider);
    _draftCtrl = TextEditingController(text: vessel.draftM.toStringAsFixed(1));
    _clearanceCtrl = TextEditingController(
      text: p.clearanceM.toStringAsFixed(1),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(activeRouteIdProvider.notifier).hydrate();
      await _refreshWaypoints();
    });
  }

  @override
  void dispose() {
    _draftCtrl.dispose();
    _clearanceCtrl.dispose();
    super.dispose();
  }

  Future<void> _refreshWaypoints() async {
    final routeId = ref.read(activeRouteIdProvider);
    if (routeId == null) {
      if (mounted) setState(() => _waypoints = []);
      return;
    }

    final rows = await ref
        .read(routeRepositoryProvider)
        .waypointsOrdered(routeId);
    if (mounted) setState(() => _waypoints = rows);
  }

  Future<void> _persistShipParams() async {
    final draft = double.tryParse(_draftCtrl.text.replaceAll(',', '.'));
    final clearance = double.tryParse(_clearanceCtrl.text.replaceAll(',', '.'));
    if (draft != null && draft > 0) {
      await ref.read(vesselPrefsProvider.notifier).setDraftM(draft);
    }
    if (clearance != null && clearance >= 0) {
      await ref
          .read(shipRoutingPreferencesProvider.notifier)
          .setClearanceM(clearance);
    }
  }

  Future<void> _persistWaypoints() async {
    final routeId = ref.read(activeRouteIdProvider);
    if (routeId == null) return;

    final drafts = _waypoints
        .map((w) => WaypointDraft(lat: w.lat, lon: w.lon, name: w.name))
        .toList(growable: false);
    await ref.read(routeRepositoryProvider).replaceWaypoints(routeId, drafts);
    await _refreshWaypoints();
  }

  Future<void> _onWaypointReorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;
    setState(() {
      final item = _waypoints.removeAt(oldIndex);
      _waypoints.insert(newIndex, item);
    });
    await _persistWaypoints();
  }

  Future<void> _onWaypointDelete(int index) async {
    setState(() => _waypoints.removeAt(index));
    await _persistWaypoints();
  }

  Future<void> _computeAdvisory() async {
    final l10n = AppLocalizations.of(context)!;
    await _persistShipParams();

    final routeId = ref.read(activeRouteIdProvider);
    if (routeId == null) {
      setState(() => _lastMessage = l10n.routeAdvisoryNoRoute);
      return;
    }

    final wps = await ref
        .read(routeRepositoryProvider)
        .waypointsOrdered(routeId);
    if (wps.length < 2) {
      setState(() => _lastMessage = l10n.routeAdvisoryNeedTwoPoints);
      return;
    }

    final ship = ref.read(shipRoutingPreferencesProvider);
    final vessel = ref.read(vesselPrefsProvider);

    DemoNavigationLayersIndex chartIndex;
    try {
      chartIndex = await ref.read(demoNavigationLayersIndexProvider.future);
    } catch (_) {
      if (!mounted) return;
      setState(() => _lastMessage = l10n.routeAdvisoryChartLoadFailed);
      return;
    }

    final scenario = NavigationLayersRoutingScenario.fromIndex(chartIndex);
    final start = wps.first;
    final goal = wps.last;

    final result = computeAdvisoryRoute(
      grid: scenario.grid,
      forbidden: scenario.forbidden,
      draftM: vessel.draftM,
      clearanceM: ship.clearanceM,
      startLat: start.lat,
      startLon: start.lon,
      goalLat: goal.lat,
      goalLon: goal.lon,
    );

    try {
      await ref
          .read(auditRepositoryProvider)
          .record(
            sessionId: ref.read(sessionIdProvider),
            module: 'M1',
            action: 'auto_guidance_compute',
            contextJson: jsonEncode({
              'ok': result.isOk,
              'reason': result.failureReason,
              'pts': result.points.length,
              'grid': 'navigation_layers_geojson',
            }),
          );
    } catch (_) {}

    if (!mounted) return;

    if (result.isOk) {
      ref.read(advisoryPolylineProvider.notifier).setPolyline(result.points);
      setState(() => _lastMessage = l10n.routeAdvisoryComputed);
    } else {
      ref.read(advisoryPolylineProvider.notifier).setPolyline(null);
      setState(
        () => _lastMessage = l10n.errorRoutingFailed,
      );
      if (mounted) showCwErrorSnackBar(context, CwErrorKind.routingFailed);
    }
  }

  void _clearAdvisory() {
    ref.read(advisoryPolylineProvider.notifier).setPolyline(null);
    setState(() => _lastMessage = null);
  }

  RouteDepthSafetyResult? _depthSafety(
    AsyncValue<DemoNavigationLayersIndex> chartAsync,
    ShipRoutingParams ship,
    double draftM,
  ) {
    if (_waypoints.isEmpty) return null;
    final draft =
        double.tryParse(_draftCtrl.text.replaceAll(',', '.')) ?? draftM;
    final clearance =
        double.tryParse(_clearanceCtrl.text.replaceAll(',', '.')) ??
        ship.clearanceM;
    return chartAsync.maybeWhen(
      data: (index) => checkRouteDepthSafety(
        waypoints: _waypoints,
        grid: NavigationLayersRoutingScenario.fromIndex(index).grid,
        draftM: draft,
        clearanceM: clearance,
      ),
      orElse: () => null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final advisoryOk = ref.watch(advisoryDisclaimerAcceptedProvider);
    final routeId = ref.watch(activeRouteIdProvider);
    final ship = ref.watch(shipRoutingPreferencesProvider);
    final vessel = ref.watch(vesselPrefsProvider);
    final chartAsync = ref.watch(demoNavigationLayersIndexProvider);
    final showCorridor = ref.watch(routeCorridorVisibleProvider);
    final safety = _depthSafety(chartAsync, ship, vessel.draftM);

    ref.listen<VesselProfile>(vesselPrefsProvider, (prev, next) {
      if (prev?.draftM != next.draftM && mounted) {
        _draftCtrl.text = next.draftM.toStringAsFixed(1);
        setState(() {});
      }
    });

    ref.listen<String?>(activeRouteIdProvider, (prev, next) {
      if (prev != next) unawaited(_refreshWaypoints());
    });

    final coordPoints = _waypoints
        .map((w) => (lat: w.lat, lon: w.lon))
        .toList(growable: false);

    return LayoutBuilder(
      builder: (context, constraints) {
        final split = CwSplitView.isSplitWidth(constraints.maxWidth);
        final detail = _buildDetailPanel(
          l10n: l10n,
          theme: theme,
          advisoryOk: advisoryOk,
          routeId: routeId,
          coordPoints: coordPoints,
          showCorridor: showCorridor,
          safety: safety,
        );

        if (split) {
          return CwSplitView(
            master: Padding(
              padding: const EdgeInsets.all(CwSpacing.m),
              child: RouteMapPanel(waypoints: coordPoints),
            ),
            detail: detail,
          );
        }

        return detail;
      },
    );
  }

  Widget _buildDetailPanel({
    required AppLocalizations l10n,
    required ThemeData theme,
    required bool advisoryOk,
    required String? routeId,
    required List<({double lat, double lon})> coordPoints,
    required bool showCorridor,
    required RouteDepthSafetyResult? safety,
  }) {
    return ListView(
      padding: const EdgeInsets.all(CwSpacing.m),
      children: [
        Text(l10n.routeScreenTitle, style: theme.textTheme.headlineSmall),
        const SizedBox(height: CwSpacing.m),
        if (!advisoryOk) ...[
          CwCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.routeAdvisoryDisclaimerTitle,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: CwSpacing.s),
                Text(
                  l10n.routeAdvisoryDisclaimerBody,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: CwSpacing.m),
                CwButton(
                  label: l10n.routeAdvisoryDisclaimerAccept,
                  onPressed: () => ref
                      .read(advisoryDisclaimerAcceptedProvider.notifier)
                      .accept(),
                ),
              ],
            ),
          ),
        ] else ...[
          Text(
            l10n.routeActiveRouteLabel(routeId ?? l10n.routeActiveRouteUnknown),
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: CwSpacing.m),
          RouteStatsCard(waypoints: coordPoints),
          const SizedBox(height: CwSpacing.m),
          CwCard(
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.routeShowCorridor),
              subtitle: Text(l10n.routeShowCorridorSubtitle),
              value: showCorridor,
              onChanged: (v) => unawaited(
                ref.read(routeCorridorVisibleProvider.notifier).setVisible(v),
              ),
            ),
          ),
          const SizedBox(height: CwSpacing.m),
          WaypointListPanel(
            waypoints: _waypoints,
            onReorder: (old, next) => unawaited(_onWaypointReorder(old, next)),
            onDelete: (i) => unawaited(_onWaypointDelete(i)),
          ),
          if (safety != null) ...[
            const SizedBox(height: CwSpacing.m),
            SafetyCheckBanner(
              isUnsafe: !safety.isSafe,
              unsafeWaypointIndex: safety.unsafeWaypointIndex,
            ),
          ],
          const SizedBox(height: CwSpacing.m),
          CwCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _draftCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.routeShipDraftM,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: CwSpacing.m),
                TextField(
                  controller: _clearanceCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.routeShipClearanceM,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),
          const SizedBox(height: CwSpacing.m),
          CwButton(
            label: l10n.routePlanRoute,
            onPressed: _computeAdvisory,
          ),
          const SizedBox(height: CwSpacing.s),
          CwButton(
            label: l10n.routeClearAdvisory,
            variant: CwButtonVariant.secondary,
            onPressed: _clearAdvisory,
          ),
          const SizedBox(height: CwSpacing.m),
          Text(
            l10n.routeSyntheticNote,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          if (_lastMessage != null) ...[
            const SizedBox(height: CwSpacing.m),
            Text(_lastMessage!, style: theme.textTheme.bodyMedium),
          ],
        ],
      ],
    );
  }
}
