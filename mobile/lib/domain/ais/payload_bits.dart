// AIS VDM payload: 6-bit armoring → битовый поток (ITU-R M.1371).

/// Декодирует строку полезной нагрузки AIVDM в массив бит (MSB первый в каждой 6-бит группе).
List<bool> aisArmoringToBits(String payload) {
  final bits = <bool>[];
  for (final unit in payload.codeUnits) {
    var v = unit - 48;
    if (v > 40) {
      v -= 8;
    }
    if (v < 0 || v > 63) {
      throw FormatException('invalid AIS armoring character', payload);
    }
    for (var i = 5; i >= 0; i--) {
      bits.add(((v >> i) & 1) == 1);
    }
  }
  return bits;
}

bool _bit(List<bool> bits, int index) => bits[index];

int readUnsignedBits(List<bool> bits, int start, int length) {
  var val = 0;
  for (var i = 0; i < length; i++) {
    val = (val << 1) | (_bit(bits, start + i) ? 1 : 0);
  }
  return val;
}

/// Знаковое целое в дополнении до двух (AIS поля фиксированной ширины).
int readSignedBits(List<bool> bits, int start, int length) {
  final u = readUnsignedBits(bits, start, length);
  final signMask = 1 << (length - 1);
  if ((u & signMask) != 0) {
    return u - (1 << length);
  }
  return u;
}
