import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/active_route_id.dart';
import '../../core/advisory_disclaimer_gate.dart';
import '../../core/providers.dart';
import '../../core/ship_routing_preferences.dart';
import '../../domain/map/demo_navigation_layers_index.dart';
import '../../domain/routing/auto_guidance.dart';
import '../../domain/routing/navigation_layers_depth_grid.dart';
import '../../l10n/app_localizations.dart';
import 'advisory_polyline_notifier.dart';
import 'demo_navigation_layers_index_provider.dart';

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

  @override
  void initState() {
    super.initState();
    final p = ref.read(shipRoutingPreferencesProvider);
    _draftCtrl = TextEditingController(text: p.draftM.toStringAsFixed(1));
    _clearanceCtrl = TextEditingController(
      text: p.clearanceM.toStringAsFixed(1),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(activeRouteIdProvider.notifier).hydrate();
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _draftCtrl.dispose();
    _clearanceCtrl.dispose();
    super.dispose();
  }

  Future<void> _persistShipParams() async {
    final draft = double.tryParse(_draftCtrl.text.replaceAll(',', '.'));
    final clearance = double.tryParse(_clearanceCtrl.text.replaceAll(',', '.'));
    final n = ref.read(shipRoutingPreferencesProvider.notifier);
    if (draft != null && draft > 0) await n.setDraftM(draft);
    if (clearance != null && clearance >= 0) await n.setClearanceM(clearance);
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
      draftM: ship.draftM,
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
        () =>
            _lastMessage = l10n.routeAdvisoryFailed(result.failureReason ?? ''),
      );
    }
  }

  void _clearAdvisory() {
    ref.read(advisoryPolylineProvider.notifier).setPolyline(null);
    setState(() => _lastMessage = null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final advisoryOk = ref.watch(advisoryDisclaimerAcceptedProvider);
    final routeId = ref.watch(activeRouteIdProvider);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(l10n.routeScreenTitle, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 12),
        if (!advisoryOk) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.routeAdvisoryDisclaimerTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.routeAdvisoryDisclaimerBody,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => ref
                        .read(advisoryDisclaimerAcceptedProvider.notifier)
                        .accept(),
                    child: Text(l10n.routeAdvisoryDisclaimerAccept),
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
          Text(
            l10n.routeActiveRouteLabel(routeId ?? l10n.routeActiveRouteUnknown),
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _draftCtrl,
            decoration: InputDecoration(
              labelText: l10n.routeShipDraftM,
              border: const OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _clearanceCtrl,
            decoration: InputDecoration(
              labelText: l10n.routeShipClearanceM,
              border: const OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              FilledButton(
                onPressed: _computeAdvisory,
                child: Text(l10n.routeComputeAdvisory),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: _clearAdvisory,
                child: Text(l10n.routeClearAdvisory),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.routeSyntheticNote,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          if (_lastMessage != null) ...[
            const SizedBox(height: 12),
            Text(_lastMessage!, style: theme.textTheme.bodyMedium),
          ],
        ],
      ],
    );
  }
}
