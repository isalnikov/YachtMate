import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/language_button.dart';
import '../map/map_screen.dart';
import '../route/route_screen.dart';
import '../weather/weather_screen.dart';

/// Five-tab shell aligned with [`docs/ui/`](/docs/ui/).
class ShellScreen extends ConsumerStatefulWidget {
  const ShellScreen({super.key});

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final destinations = [
      (Icons.map_outlined, l10n.tabMap),
      (Icons.route_outlined, l10n.tabRoute),
      (Icons.air_outlined, l10n.tabWeather),
      (Icons.anchor_outlined, l10n.tabMooring),
      (Icons.more_horiz, l10n.tabMore),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: const [LanguageButton()],
      ),
      body: KeyedSubtree(
        key: ValueKey(_index),
        child: _tabBody(_index, destinations),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          for (final d in destinations)
            NavigationDestination(icon: Icon(d.$1), label: d.$2),
        ],
      ),
    );
  }
}

Widget _tabBody(int index, List<(IconData, String)> destinations) {
  return switch (index) {
    0 => const MapScreen(),
    1 => const RouteScreen(),
    2 => const WeatherScreen(),
    3 => _PlaceholderTab(icon: destinations[3].$1, title: destinations[3].$2),
    4 => _PlaceholderTab(icon: destinations[4].$1, title: destinations[4].$2),
    _ => const SizedBox.shrink(),
  };
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.bootstrapNote,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
