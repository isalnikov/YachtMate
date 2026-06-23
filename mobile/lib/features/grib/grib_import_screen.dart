import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/providers.dart';
import '../../core/theme/cw_theme_extensions.dart';
import '../../core/theme/cw_tokens.dart';
import '../../core/theme/cw_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_button.dart';
import '../../widgets/cw_empty_state.dart';
import 'grib_import_storage.dart';
import 'widgets/grib_file_list.dart';

/// GRIB import screen with MVP GRIB2 decode (step-44).
class GribImportScreen extends ConsumerStatefulWidget {
  const GribImportScreen({
    super.key,
    this.demoFixtureBuilder,
  });

  /// Test hook: inject a synthetic GRIB file instead of the platform picker.
  final Future<String?> Function()? demoFixtureBuilder;

  @override
  ConsumerState<GribImportScreen> createState() => _GribImportScreenState();
}

class _GribImportScreenState extends ConsumerState<GribImportScreen> {
  List<GribImportFile> _files = const [];
  bool _importing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reloadFiles());
  }

  Future<void> _reloadFiles() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final stored = loadGribImports(prefs);
    final decoded = <GribImportFile>[];
    for (final file in stored) {
      decoded.add(await decodeGribImportFile(file));
    }
    if (!mounted) return;
    setState(() => _files = decoded);
  }

  Future<String?> _pickImportPath() async {
    if (widget.demoFixtureBuilder != null) {
      return widget.demoFixtureBuilder!();
    }

    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['grib', 'grb', 'grb2', 'grb1'],
    );
    final picked = res?.files.single;
    if (picked == null) return null;

    if (picked.path != null) {
      return picked.path;
    }

    if (picked.bytes == null) return null;
    final dir = await getApplicationDocumentsDirectory();
    final target = File(p.join(dir.path, 'grib_imports', picked.name));
    await target.parent.create(recursive: true);
    await target.writeAsBytes(picked.bytes!);
    return target.path;
  }

  Future<void> _importGrib(AppLocalizations l10n) async {
    if (_importing) return;

    setState(() => _importing = true);
    try {
      final path = await _pickImportPath();
      if (path == null) return;

      final prefs = ref.read(sharedPreferencesProvider);
      await addGribImport(prefs, path);
      await _reloadFiles();

      if (!mounted) return;
      final imported = _files.firstWhere(
        (f) => f.path == path,
        orElse: () => GribImportFile(path: path),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            imported.decodeError ?? l10n.gribImportParsed,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _importing = false);
    }
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
            l10n.gribImportBody,
            style: CwTypography.body(color: colors.textMuted),
          ),
          const SizedBox(height: CwSpacing.m),
          CwButton(
            key: const Key('grib_import_button'),
            label: l10n.gribImport,
            variant: CwButtonVariant.secondary,
            icon: Icons.upload_file_outlined,
            loading: _importing,
            onPressed: _importing ? null : () => _importGrib(l10n),
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
                      message: l10n.gribImportBody,
                      ctaLabel: l10n.gribImport,
                      onCtaPressed: _importing
                          ? null
                          : () => _importGrib(l10n),
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
