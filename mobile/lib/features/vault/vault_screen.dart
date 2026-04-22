import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/crew/crew_controller.dart';
import '../../core/providers.dart';
import '../../core/vault_prefs_controller.dart';
import '../../data/local/app_database.dart';
import '../../l10n/app_localizations.dart';

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
        setState(() => _filesFuture = _reloadFiles());
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
    if (!ok) return;
    ref.read(vaultSessionUnlockedProvider.notifier).state = true;
    ref.read(vaultSessionPinProvider.notifier).state = _pinUnlock.text.trim();
    setState(() => _filesFuture = _reloadFiles());
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
    setState(() => _filesFuture = _reloadFiles());
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
    setState(() => _filesFuture = _reloadFiles());
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
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.vaultPinSetupTitle),
            TextField(
              controller: _pinCreate,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.vaultPinHint),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _pinRepeat,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.vaultPinUnlockTitle),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => _createPin(l10n),
              child: Text(l10n.logbookSave),
            ),
          ],
        ),
      );
    }

    if (!unlocked) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.vaultLockedHint),
            TextField(
              controller: _pinUnlock,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.vaultPinUnlockTitle),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => _unlock(l10n),
              child: Text(l10n.vaultUnlock),
            ),
          ],
        ),
      );
    }

    return FutureBuilder<List<VaultFileRow>>(
      future: _filesFuture ?? _reloadFiles(),
      builder: (ctx, snap) {
        final rows = snap.data ?? [];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => _pickAndSave(l10n),
                      child: Text(l10n.vaultPickFile),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  snap.connectionState == ConnectionState.waiting &&
                      rows.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : rows.isEmpty
                  ? Center(child: Text(l10n.vaultEmpty))
                  : ListView.builder(
                      itemCount: rows.length,
                      itemBuilder: (c, i) {
                        final r = rows[i];
                        return ListTile(
                          title: Text(r.displayName),
                          subtitle: Text('${r.plainSizeBytes} bytes'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _delete(r, l10n),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
