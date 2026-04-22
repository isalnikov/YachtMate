import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';

/// Заглушка импорта GRIB с сохранением пути (F10 — декодер не входит в MVP).
class GribImportScreen extends ConsumerStatefulWidget {
  const GribImportScreen({super.key});

  @override
  ConsumerState<GribImportScreen> createState() => _GribImportScreenState();
}

class _GribImportScreenState extends ConsumerState<GribImportScreen> {
  static const prefsKey = 'gribImportPathStub';

  String? _path;

  @override
  void initState() {
    super.initState();
    _path = ref.read(sharedPreferencesProvider).getString(prefsKey);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.gribStubBody, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          if (_path != null)
            Text('${l10n.gribLastPath}: $_path',
                style: Theme.of(context).textTheme.bodySmall),
          const Spacer(),
          FilledButton(
            onPressed: () async {
              // File picker optional: keep stub — user path from share target in later phase
              final p = ref.read(sharedPreferencesProvider);
              const demo = '/demo/path/weather.grb';
              await p.setString(prefsKey, demo);
              setState(() => _path = demo);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.gribStubSaved)),
                );
              }
            },
            child: Text(l10n.gribSimulatePick),
          ),
        ],
      ),
    );
  }
}
