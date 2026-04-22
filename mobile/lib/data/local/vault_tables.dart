import 'package:drift/drift.dart';

/// Метаданные файла в зашифрованном хранилище (Фаза 7.5).
@DataClassName('VaultFileRow')
class VaultFiles extends Table {
  TextColumn get id => text()();

  TextColumn get displayName => text()();

  /// AES-GCM: nonce + ciphertext, base64.
  TextColumn get cipherPayloadBase64 => text()();

  IntColumn get plainSizeBytes => integer()();

  IntColumn get createdAtMs => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
