import 'dart:convert';
import 'dart:math';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/vault/vault_crypto.dart';
import '../local/app_database.dart';

/// Метаданные + шифртекст в БД (Фаза 7.5).
class VaultRepository {
  VaultRepository(this._db);

  final AppDatabase _db;

  static const _uuid = Uuid();

  Future<VaultFileRow> saveEncrypted({
    required String displayName,
    required Uint8List plainBytes,
    required String pin,
    required String vaultSalt,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now().millisecondsSinceEpoch;
    final payload = VaultCrypto.encryptToBase64(plainBytes, pin, vaultSalt);
    await _db
        .into(_db.vaultFiles)
        .insert(
          VaultFilesCompanion.insert(
            id: id,
            displayName: displayName.trim().isEmpty
                ? 'file'
                : displayName.trim(),
            cipherPayloadBase64: payload,
            plainSizeBytes: plainBytes.length,
            createdAtMs: now,
          ),
        );
    return await (_db.select(
      _db.vaultFiles,
    )..where((v) => v.id.equals(id))).getSingle();
  }

  Future<List<VaultFileRow>> listFiles() {
    return (_db.select(
      _db.vaultFiles,
    )..orderBy([(v) => OrderingTerm.desc(v.createdAtMs)])).get();
  }

  Uint8List? decryptIfPinOk(VaultFileRow row, String pin, String vaultSalt) {
    try {
      return VaultCrypto.decryptFromBase64(
        row.cipherPayloadBase64,
        pin,
        vaultSalt,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteFile(String id) async {
    await (_db.delete(_db.vaultFiles)..where((v) => v.id.equals(id))).go();
  }

  /// Один раз на установку — для соли PIN.
  static String randomSalt() {
    final r = Random.secure();
    final b = List<int>.generate(16, (_) => r.nextInt(256));
    return base64Encode(b);
  }
}
