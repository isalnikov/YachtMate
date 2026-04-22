/// Проверка контрольной суммы NMEA 0183 (XOR между `$`/`!` и `*`).
bool nmeaChecksumValid(String line) {
  final star = line.lastIndexOf('*');
  if (star < 0 || star + 3 > line.length) return false;

  final hex = line.substring(star + 1, star + 3);
  final expected = int.tryParse(hex, radix: 16);
  if (expected == null) return false;

  var xor = 0;
  final start = line.startsWith('!') || line.startsWith(r'$') ? 1 : 0;
  for (var i = start; i < star; i++) {
    xor ^= line.codeUnitAt(i);
  }
  return xor == expected;
}
