import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_badge.dart';
import '../../../widgets/cw_card.dart';
import '../../../widgets/cw_list_tile.dart';
import '../grib_import_storage.dart';

/// Scrollable list of imported GRIB files — one [CwCard] per entry.
class GribFileList extends StatelessWidget {
  const GribFileList({
    super.key,
    required this.files,
    this.onFileTap,
  });

  final List<GribImportFile> files;
  final ValueChanged<GribImportFile>? onFileTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: files.length,
      separatorBuilder: (_, __) => const SizedBox(height: CwSpacing.s),
      itemBuilder: (ctx, i) => GribFileCard(
        file: files[i],
        onTap: onFileTap == null ? null : () => onFileTap!(files[i]),
      ),
    );
  }
}

class GribFileCard extends StatelessWidget {
  const GribFileCard({
    super.key,
    required this.file,
    this.onTap,
  });

  final GribImportFile file;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;

    return CwCard(
      key: Key('grib_file_${file.path}'),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CwListTile(
            leading: const Icon(Icons.cloud_download_outlined),
            title: file.fileName,
            subtitle: file.path,
            trailing: CwBadge(
              label: l10n.gribStatusPending,
              variant: CwBadgeVariant.info,
            ),
            onTap: onTap,
          ),
          const SizedBox(height: CwSpacing.xs),
          Text(
            l10n.gribStubBody,
            style: CwTypography.caption(color: colors.textMuted),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
