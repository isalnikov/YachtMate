import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/cw_theme_extensions.dart';
import '../../l10n/app_localizations.dart';
import 'shell_tab_provider.dart';
import '../../widgets/cw_app_bar.dart';
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
  static const double _railBreakpointWidth = 720;
  static const double _navIconSize = CwAppBar.iconSize;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;

    final destinations = [
      (Icons.map_outlined, l10n.tabMap),
      (Icons.route_outlined, l10n.tabRoute),
      (Icons.air_outlined, l10n.tabWeather),
      (Icons.anchor_outlined, l10n.tabMooring),
      (Icons.more_horiz, l10n.tabMore),
    ];

    final index = ref.watch(shellTabIndexProvider);
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= _railBreakpointWidth;
    final useExtendedRail = width >= 900;
    final onMap = index == 0;

    final body = KeyedSubtree(key: ValueKey(index), child: _tabBody(index));

    final appBar = CwAppBar(
      title: destinations[index].$2,
      transparent: onMap,
      showBack: false,
      actions: const [LanguageButton()],
    );

    final railTheme = NavigationRailThemeData(
      backgroundColor: colors.deckBlue,
      indicatorColor: colors.accentTeal.withValues(alpha: 0.35),
      selectedIconTheme: IconThemeData(color: colors.accentTeal, size: _navIconSize),
      unselectedIconTheme: IconThemeData(color: colors.textMuted, size: _navIconSize),
      selectedLabelTextStyle: TextStyle(
        color: colors.accentTeal,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: TextStyle(
        color: colors.textMuted,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );

    final barTheme = NavigationBarThemeData(
      backgroundColor: colors.deckBlue,
      indicatorColor: colors.accentTeal.withValues(alpha: 0.35),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? colors.accentTeal : colors.textMuted,
          size: _navIconSize,
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          color: selected ? colors.accentTeal : colors.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        );
      }),
    );

    if (wide) {
      return Scaffold(
        extendBodyBehindAppBar: onMap,
        appBar: appBar,
        body: NavigationRailTheme(
          data: railTheme,
          child: Row(
            children: [
              NavigationRail(
                extended: useExtendedRail,
                selectedIndex: index,
                onDestinationSelected: (i) =>
                    ref.read(shellTabIndexProvider.notifier).selectTab(i),
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
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: onMap,
      appBar: appBar,
      body: body,
      bottomNavigationBar: NavigationBarTheme(
        data: barTheme,
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) =>
              ref.read(shellTabIndexProvider.notifier).selectTab(i),
          destinations: [
            for (final d in destinations)
              NavigationDestination(icon: Icon(d.$1), label: d.$2),
          ],
        ),
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
