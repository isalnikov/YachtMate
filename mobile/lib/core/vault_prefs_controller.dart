import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/vault_repository.dart';
import '../domain/vault/vault_crypto.dart';
import 'providers.dart';

/// Соль и хэш PIN для сейфа (Фаза 7.5).
class VaultPrefs {
  const VaultPrefs({required this.salt, required this.pinHash});

  final String? salt;
  final String? pinHash;

  bool get hasPin => pinHash != null && pinHash!.isNotEmpty;

  static VaultPrefs read(SharedPreferences p) {
    return VaultPrefs(
      salt: p.getString(VaultPrefsNotifier.saltKey),
      pinHash: p.getString(VaultPrefsNotifier.pinHashKey),
    );
  }
}

class VaultPrefsNotifier extends StateNotifier<VaultPrefs> {
  VaultPrefsNotifier(this._prefs) : super(VaultPrefs.read(_prefs));

  final SharedPreferences _prefs;

  static const saltKey = 'vault_salt_v1';
  static const pinHashKey = 'vault_pin_hash_v1';

  Future<void> ensureSalt() async {
    if ((_prefs.getString(saltKey) ?? '').isNotEmpty) return;
    await _prefs.setString(saltKey, VaultRepository.randomSalt());
    state = VaultPrefs.read(_prefs);
  }

  Future<void> setPin(String pin) async {
    await ensureSalt();
    final salt = _prefs.getString(saltKey)!;
    final h = VaultCrypto.hashPin(pin, salt);
    await _prefs.setString(pinHashKey, h);
    state = VaultPrefs.read(_prefs);
  }

  bool verifyPin(String pin) {
    final salt = _prefs.getString(saltKey);
    final want = _prefs.getString(pinHashKey);
    if (salt == null || want == null) return false;
    return VaultCrypto.hashPin(pin, salt) == want;
  }

  Future<void> clearVaultIdentity() async {
    await _prefs.remove(pinHashKey);
    state = VaultPrefs.read(_prefs);
  }
}

final vaultPrefsProvider =
    StateNotifierProvider<VaultPrefsNotifier, VaultPrefs>(
      (ref) => VaultPrefsNotifier(ref.watch(sharedPreferencesProvider)),
    );

/// Сессия разблокировки сейфа (только в памяти процесса).
final vaultSessionUnlockedProvider = StateProvider<bool>((ref) => false);

/// PIN в памяти после успешной разблокировки (шифрование документов).
final vaultSessionPinProvider = StateProvider<String?>((ref) => null);
