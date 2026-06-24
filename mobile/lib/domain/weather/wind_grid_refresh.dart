/// When the map center moves beyond [thresholdDeg], refetch the wind grid (step 62).
bool shouldRefreshWindGrid({
  required double fromLat,
  required double fromLon,
  required double toLat,
  required double toLon,
  double thresholdDeg = 0.04,
}) {
  return (toLat - fromLat).abs() > thresholdDeg ||
      (toLon - fromLon).abs() > thresholdDeg;
}
