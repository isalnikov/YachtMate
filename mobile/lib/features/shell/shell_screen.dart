import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/language_button.dart';
import '../map/map_screen.dart';
import '../mooring/mooring_screen.dart';
import '../more/more_menu_screen.dart';
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

  static const double _railBreakpointWidth = 720;

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

    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= _railBreakpointWidth;
    final useExtendedRail = width >= 900;

    final body = KeyedSubtree(key: ValueKey(_index), child: _tabBody(_index));

    if (wide) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.appTitle),
          actions: const [LanguageButton()],
        ),
        body: Row(
          children: [
            NavigationRail(
              extended: useExtendedRail,
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              labelType: useExtendedRail
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              destinations: [
                for (final d in destinations)
                  NavigationRailDestination(
                    icon: Icon(d.$1),
                    label: Text(d.$2),
                  ),
              ],
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: const [LanguageButton()],
      ),
      body: body,
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

Widget _tabBody(int index) {
  return switch (index) {
    0 => const MapScreen(),
    1 => const RouteScreen(),
    2 => const WeatherScreen(),
    3 => const MooringScreen(),
    4 => const MoreMenuScreen(),
    _ => const SizedBox.shrink(),
  };
}
