import 'dart:typed_data';

/// Builds a tiny valid GRIB2 file with one 2×2 wind component for tests.
Uint8List buildMinimalWindGrib2({
  int parameterNumber = 2,
  List<int> packedValues = const [1, 2, 3, 4],
}) {
  final sections = <Uint8List>[
    _section1(),
    _section3(),
    _section4(parameterNumber: parameterNumber),
    _section5(),
    _section7(packedValues),
    _section8(),
  ];

  final out = BytesBuilder(copy: false);
  out.add(_section0(0));
  for (final section in sections) {
    out.add(section);
  }
  final bytes = out.toBytes();
  _patchTotalLength(bytes, bytes.length);
  return bytes;
}

void _patchTotalLength(Uint8List bytes, int totalLength) {
  final encoded = _uint64(totalLength);
  for (var i = 0; i < 8; i++) {
    bytes[7 + i] = encoded[i];
  }
}

Uint8List buildMinimalWindUvGrib2() {
  final u = buildMinimalWindGrib2(parameterNumber: 2);
  final v = buildMinimalWindGrib2(
    parameterNumber: 3,
    packedValues: const [0, 1, 0, 1],
  );
  return Uint8List.fromList([...u, ...v]);
}

Uint8List _section0(int totalLength) {
  return Uint8List.fromList([
    0x47, 0x52, 0x49, 0x42, // GRIB
    0x00, // reserved
    0x00, // discipline meteorological
    0x02, // edition 2
    ..._uint64(totalLength),
    0x00, // reserved
  ]);
}

Uint8List _section1() {
  return _section(
    1,
    [
      0x00,
      0x62, // centre 98
      0x00,
      0x00, // sub-centre
      0x02, // master table
      0x01, // local table
      0x01, // significance: start of forecast
      ..._uint16(2024),
      0x06, // month
      15, // day
      0x0C, // hour
      0x00, // minute
      0x00, // second
      0x00, // production status
      0x01, // forecast products
    ],
  );
}

Uint8List _section3() {
  return _section(
    3,
    [
      0x00, // predefined grid
      ..._uint32(4), // points
      0x00, // no optional list
      ..._uint16(0), // lat/lon template
      0x06, // spherical earth
      0xFF,
      ..._uint32(0xFFFFFFFF),
      0xFF,
      ..._uint32(0xFFFFFFFF),
      0xFF,
      ..._uint32(0xFFFFFFFF),
      ..._uint32(2), // Ni
      ..._uint32(2), // Nj
      ..._int32(40_000_000),
      ..._int32(10_000_000),
      0xC0, // i/j increments given
      ..._int32(41_000_000),
      ..._int32(11_000_000),
      ..._int32(1_000_000),
      ..._int32(1_000_000),
      0x40, // scanning mode
    ],
  );
}

Uint8List _section4({required int parameterNumber}) {
  return _section(
    4,
    [
      ..._uint16(0), // coordinate values
      ..._uint16(0), // template 4.0
      0x02, // momentum
      parameterNumber,
      0x02, // forecast
      0x00,
      0x00,
      ..._uint16(0), // hours after ref
      0x00, // minutes
      0x01, // hours unit
      0x00, // forecast time in units
      0x67, // height above ground
      0x00, // scale
      ..._uint32(10), // 10 m
      0xFF,
      0xFF,
      ..._uint32(0xFFFFFFFF),
    ],
  );
}

Uint8List _section5() {
  return _section(
    5,
    [
      ..._uint32(4),
      ..._uint16(0), // simple packing
      ..._float32(0),
      ..._int16(0),
      ..._int16(0),
      0x10, // 16 bits
      0x00,
    ],
  );
}

Uint8List _section7(List<int> values) {
  final data = <int>[];
  for (final v in values) {
    data.addAll(_uint16(v));
  }
  return _section(7, data);
}

Uint8List _section8() => Uint8List.fromList([0x37, 0x37, 0x37, 0x37]);

Uint8List _section(int number, List<int> payload) {
  final length = 4 + 1 + payload.length;
  return Uint8List.fromList([
    ..._uint32(length),
    number,
    ...payload,
  ]);
}

List<int> _uint16(int v) => [(v >> 8) & 0xFF, v & 0xFF];

List<int> _int16(int v) {
  if (v < 0) v = 0x10000 + v;
  return _uint16(v);
}

List<int> _uint32(int v) => [
  (v >> 24) & 0xFF,
  (v >> 16) & 0xFF,
  (v >> 8) & 0xFF,
  v & 0xFF,
];

List<int> _int32(int v) {
  if (v < 0) v = 0x100000000 + v;
  return _uint32(v);
}

List<int> _uint64(int v) {
  final out = <int>[];
  for (var i = 7; i >= 0; i--) {
    out.add((v >> (8 * i)) & 0xFF);
  }
  return out;
}

List<int> _float32(double v) {
  final b = ByteData(4)..setFloat32(0, v, Endian.big);
  return [b.getUint8(0), b.getUint8(1), b.getUint8(2), b.getUint8(3)];
}
