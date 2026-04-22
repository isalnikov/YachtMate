import 'dart:typed_data';

import 'package:captain_wrongel/domain/vault/vault_crypto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('VaultCrypto roundtrip', () {
    const salt = 'salt';
    const pin = '4242';
    final plain = Uint8List.fromList([1, 2, 3, 4, 200]);
    final enc = VaultCrypto.encryptToBase64(plain, pin, salt);
    final dec = VaultCrypto.decryptFromBase64(enc, pin, salt);
    expect(dec, plain);
  });

  test('hashPin stable', () {
    expect(
      VaultCrypto.hashPin('4242', 'salt'),
      VaultCrypto.hashPin('4242', 'salt'),
    );
  });
}
