import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/cw_theme_extensions.dart';
import '../../core/theme/cw_tokens.dart';
import '../../core/theme/cw_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_button.dart';
import '../../widgets/cw_empty_state.dart';
import 'grib_import_storage.dart';
import 'widgets/grib_file_list.dart';

/// GRIB import shell: file list UI with path stub until decoder (step-44).
class GribImportScreen extends ConsumerStatefulWidget {
  const GribImportScreen({super.key});

  @override
  ConsumerState<GribImportScreen> createState() => _GribImportScreenState();
}

class _GribImportScreenState extends ConsumerState<GribImportScreen> {
  List<GribImportFile> _files = const [];
  bool _importing = false;

  @override
  void initState() {
    super.initState();
    _reloadFiles();
  }

  void _reloadFiles() {
    final prefs = ref.read(sharedPreferencesProvider);
    setState(() => _files = loadGribImports(prefs));
  }

  Future<void> _simulateImport(AppLocalizations l10n) async {
    if (_importing) return;

    setState(() => _importing = true);
    await Future<void>.delayed(const Duration(milliseconds: 400));

    const demo = '/demo/path/weather.grb';
    final prefs = ref.read(sharedPreferencesProvider);
    await addGribImport(prefs, demo);

    if (!mounted) return;
    setState(() {
      _importing = false;
      _files = loadGribImports(prefs);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.gribStubSaved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;

    return Padding(
      padding: const EdgeInsets.all(CwSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.gribStubBody,
            style: CwTypography.body(color: colors.textMuted),
          ),
          const SizedBox(height: CwSpacing.m),
          CwButton(
            key: const Key('grib_import_button'),
            label: l10n.gribImport,
            variant: CwButtonVariant.secondary,
            icon: Icons.upload_file_outlined,
            loading: _importing,
            onPressed: _importing ? null : () => _simulateImport(l10n),
          ),
          if (_importing) ...[
            const SizedBox(height: CwSpacing.s),
            LinearProgressIndicator(
              minHeight: 3,
              color: colors.accentTeal,
              backgroundColor: colors.accentTeal.withValues(alpha: 0.15),
            ),
          ],
          const SizedBox(height: CwSpacing.l),
          Text(
            l10n.gribTitle,
            style: CwTypography.h2(color: colors.textPrimary),
          ),
          const SizedBox(height: CwSpacing.s),
          Expanded(
            child: _files.isEmpty
                ? Center(
                    child: CwEmptyState(
                      key: const Key('grib_empty_state'),
                      icon: Icons.cloud_off_outlined,
                      title: l10n.gribEmpty,
                      message: l10n.gribStubBody,
                      ctaLabel: l10n.gribImport,
                      onCtaPressed: _importing
                          ? null
                          : () => _simulateImport(l10n),
                    ),
                  )
                : GribFileList(
                    key: const Key('grib_file_list'),
                    files: _files,
                  ),
          ),
        ],
      ),
    );
  }
}
