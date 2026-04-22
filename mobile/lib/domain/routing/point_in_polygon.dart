/// Ray casting: точка внутри простого полигона (WGS84 плоская аппроксимация для малых bbox).
bool pointInPolygonLonLat({
  required double lon,
  required double lat,
  required List<(double lon, double lat)> ring,
}) {
  if (ring.length < 3) return false;
  var inside = false;
  for (var i = 0, j = ring.length - 1; i < ring.length; j = i++) {
    final xi = ring[i].$1;
    final yi = ring[i].$2;
    final xj = ring[j].$1;
    final yj = ring[j].$2;
    final intersect =
        ((yi > lat) != (yj > lat)) &&
        (lon < (xj - xi) * (lat - yi) / (yj - yi) + xi);
    if (intersect) inside = !inside;
  }
  return inside;
}
