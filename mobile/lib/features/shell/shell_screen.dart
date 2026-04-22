import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../map/map_screen.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _openLanguageSheet(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        sizing: StackFit.expand,
        children: [
          const MapScreen(),
          _PlaceholderTab(
            icon: destinations[1].$1,
            title: destinations[1].$2,
          ),
          _PlaceholderTab(
            icon: destinations[2].$1,
            title: destinations[2].$2,
          ),
          _PlaceholderTab(
            icon: destinations[3].$1,
            title: destinations[3].$2,
          ),
          _PlaceholderTab(
            icon: destinations[4].$1,
            title: destinations[4].$2,
          ),
        ],
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

  Future<void> _openLanguageSheet(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.read(localeControllerProvider);
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.settingsTitle,
                  style: Theme.of(ctx).textTheme.titleLarge,
                ),
              ),
              ListTile(
                title: Text(l10n.localeEnglish),
                trailing: locale.languageCode == 'en' ? const Icon(Icons.check) : null,
                onTap: () async {
                  await ref
                      .read(localeControllerProvider.notifier)
                      .setLocale(const Locale('en'));
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: Text(l10n.localeRussian),
                trailing: locale.languageCode == 'ru' ? const Icon(Icons.check) : null,
                onTap: () async {
                  await ref
                      .read(localeControllerProvider.notifier)
                      .setLocale(const Locale('ru'));
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({
    required this.icon,
    required this.title,
  });

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
