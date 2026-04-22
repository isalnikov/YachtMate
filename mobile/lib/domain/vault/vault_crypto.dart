import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;

/// Шифрование небольших бинарных фрагментов (документы в сейфе, Фаза 7.5).
class VaultCrypto {
  const VaultCrypto._();

  static const _maxPlainBytes = 512 * 1024;

  static Uint8List deriveAesKey(String pin, String salt) {
    final out = sha256.convert(utf8.encode('$pin::$salt'));
    return Uint8List.fromList(out.bytes);
  }

  static String hashPin(String pin, String salt) {
    return sha256.convert(utf8.encode('pin:$pin::$salt')).toString();
  }

  static String encryptToBase64(Uint8List plain, String pin, String salt) {
    if (plain.length > _maxPlainBytes) {
      throw StateError('file_too_large');
    }
    final key = enc.Key(deriveAesKey(pin, salt));
    final iv = enc.IV(
      Uint8List.fromList(
        List<int>.generate(16, (_) => Random.secure().nextInt(256)),
      ),
    );
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final c = encrypter.encryptBytes(plain, iv: iv);
    final combined = Uint8List.fromList([...iv.bytes, ...c.bytes]);
    return base64Encode(combined);
  }

  static Uint8List decryptFromBase64(String b64, String pin, String salt) {
    final raw = base64Decode(b64);
    if (raw.length < 16) {
      throw StateError('corrupt');
    }
    final iv = enc.IV(Uint8List.sublistView(raw, 0, 16));
    final cipherBytes = Uint8List.sublistView(raw, 16);
    final key = enc.Key(deriveAesKey(pin, salt));
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    return Uint8List.fromList(
      encrypter.decryptBytes(enc.Encrypted(cipherBytes), iv: iv),
    );
  }
}
