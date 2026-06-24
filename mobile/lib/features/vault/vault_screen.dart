import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/crew/crew_controller.dart';
import '../../core/errors/cw_error_catalog.dart';
import '../../core/providers.dart';
import '../../core/theme/cw_theme_extensions.dart';
import '../../core/theme/cw_tokens.dart';
import '../../core/theme/cw_typography.dart';
import '../../core/vault_prefs_controller.dart';
import '../../data/local/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_badge.dart';
import '../../widgets/cw_button.dart';
import '../../widgets/cw_card.dart';
import '../../widgets/cw_empty_state.dart';
import '../../widgets/cw_list_tile.dart';
import 'widgets/vault_pin_panel.dart';

/// Зашифрованный сейф документов (Фаза 7.5).
class VaultScreen extends ConsumerStatefulWidget {
  const VaultScreen({super.key});

  @override
  ConsumerState<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends ConsumerState<VaultScreen> {
  final _pinCreate = TextEditingController();
  final _pinRepeat = TextEditingController();
  final _pinUnlock = TextEditingController();

  Future<List<VaultFileRow>>? _filesFuture;

  Future<List<VaultFileRow>> _reloadFiles() =>
      ref.read(vaultRepositoryProvider).listFiles();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(vaultPrefsProvider.notifier).ensureSalt();
      if (mounted) {
        setState(() {
          _filesFuture = _reloadFiles();
        });
      }
    });
  }

  @override
  void dispose() {
    _pinCreate.dispose();
    _pinRepeat.dispose();
    _pinUnlock.dispose();
    super.dispose();
  }

  Future<void> _createPin(AppLocalizations l10n) async {
    final a = _pinCreate.text.trim();
    final b = _pinRepeat.text.trim();
    if (a.length < 4 || a != b) return;
    await ref.read(vaultPrefsProvider.notifier).setPin(a);
    ref.read(vaultSessionUnlockedProvider.notifier).state = true;
    ref.read(vaultSessionPinProvider.notifier).state = a;
    setState(() {});
  }

  Future<void> _unlock(AppLocalizations l10n) async {
    final ok = ref.read(vaultPrefsProvider.notifier).verifyPin(_pinUnlock.text);
    if (!ok) {
      if (mounted) showCwErrorSnackBar(context, CwErrorKind.vaultDecrypt);
      return;
    }
    ref.read(vaultSessionUnlockedProvider.notifier).state = true;
    ref.read(vaultSessionPinProvider.notifier).state = _pinUnlock.text.trim();
    setState(() {
      _filesFuture = _reloadFiles();
    });
  }

  Future<void> _pickAndSave(AppLocalizations l10n) async {
    final pin = ref.read(vaultSessionPinProvider);
    final salt = ref.read(vaultPrefsProvider).salt;
    if (pin == null || salt == null || salt.isEmpty) return;

    final res = await FilePicker.platform.pickFiles(withData: true);
    final f = res?.files.single;
    if (f == null || f.bytes == null) return;

    await ref
        .read(vaultRepositoryProvider)
        .saveEncrypted(
          displayName: f.name,
          plainBytes: Uint8List.fromList(f.bytes!),
          pin: pin,
          vaultSalt: salt,
        );
    await ref
        .read(auditRepositoryProvider)
        .record(
          sessionId: ref.read(sessionIdProvider),
          module: 'M10',
          action: 'vault_file_add',
          contextJson: '{"bytes":${f.bytes!.length}}',
        );
    setState(() {
      _filesFuture = _reloadFiles();
    });
  }

  Future<void> _delete(VaultFileRow row, AppLocalizations l10n) async {
    if (!ref.read(crewControllerProvider).canCaptainActions) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.vaultDeleteForbidden)));
      return;
    }
    await ref.read(vaultRepositoryProvider).deleteFile(row.id);
    await ref
        .read(auditRepositoryProvider)
        .record(
          sessionId: ref.read(sessionIdProvider),
          module: 'M10',
          action: 'vault_file_delete',
          contextJson: '{"idPrefix":"${row.id.substring(0, 8)}"}',
        );
    setState(() {
      _filesFuture = _reloadFiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final prefs = ref.watch(vaultPrefsProvider);
    final unlocked = ref.watch(vaultSessionUnlockedProvider);

    if (prefs.salt == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!prefs.hasPin) {
      return VaultPinPanel(
        mode: VaultPinPanelMode.setup,
        primaryController: _pinCreate,
        confirmController: _pinRepeat,
        onSubmit: () => _createPin(l10n),
      );
    }

    if (!unlocked) {
      return VaultPinPanel(
        mode: VaultPinPanelMode.unlock,
        primaryController: _pinUnlock,
        onSubmit: () => _unlock(l10n),
      );
    }

    return _UnlockedVaultBody(
      l10n: l10n,
      filesFuture: _filesFuture ?? _reloadFiles(),
      onPickFile: () => _pickAndSave(l10n),
      onDelete: (row) => _delete(row, l10n),
      canDelete: ref.watch(crewControllerProvider).canCaptainActions,
    );
  }
}

class _UnlockedVaultBody extends StatelessWidget {
  const _UnlockedVaultBody({
    required this.l10n,
    required this.filesFuture,
    required this.onPickFile,
    required this.onDelete,
    required this.canDelete,
  });

  final AppLocalizations l10n;
  final Future<List<VaultFileRow>> filesFuture;
  final VoidCallback onPickFile;
  final void Function(VaultFileRow row) onDelete;
  final bool canDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;

    return Padding(
      padding: const EdgeInsets.all(CwSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.lock_open_outlined,
                size: 28,
                color: colors.safe,
                semanticLabel: 'Vault unlocked',
              ),
              const SizedBox(width: CwSpacing.s),
              Expanded(
                child: Text(
                  l10n.vaultTitle,
                  style: CwTypography.h2(color: colors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: CwSpacing.m),
          CwButton(
            label: l10n.vaultPickFile,
            variant: CwButtonVariant.secondary,
            icon: Icons.upload_file_outlined,
            onPressed: onPickFile,
          ),
          const SizedBox(height: CwSpacing.l),
          Expanded(
            child: FutureBuilder<List<VaultFileRow>>(
              future: filesFuture,
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting &&
                    !snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final rows = snap.data ?? [];
                if (rows.isEmpty) {
                  return Center(
                    child: CwEmptyState(
                      icon: Icons.folder_off_outlined,
                      title: l10n.vaultEmpty,
                    ),
                  );
                }
                return CwCard(
                  padding: const EdgeInsets.symmetric(vertical: CwSpacing.s),
                  child: ListView.separated(
                    itemCount: rows.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: colors.accentTeal.withValues(alpha: 0.12),
                    ),
                    itemBuilder: (c, i) => _VaultFileRow(
                      row: rows[i],
                      l10n: l10n,
                      onDelete: canDelete ? () => onDelete(rows[i]) : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _VaultFileRow extends StatelessWidget {
  const _VaultFileRow({
    required this.row,
    required this.l10n,
    this.onDelete,
  });

  final VaultFileRow row;
  final AppLocalizations l10n;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CwSpacing.m),
      child: CwListTile(
        leading: const Icon(Icons.description_outlined),
        title: row.displayName,
        subtitle: '${row.plainSizeBytes} bytes',
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CwBadge(
              label: l10n.vaultEncryptedBadge,
              variant: CwBadgeVariant.safe,
            ),
            if (onDelete != null) ...[
              const SizedBox(width: CwSpacing.s),
              CwIconButton(
                icon: Icons.delete_outline,
                variant: CwButtonVariant.tertiary,
                semanticLabel: 'Delete vault file',
                onPressed: onDelete,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
