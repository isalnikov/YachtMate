import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../../domain/tides/tide_demo_models.dart';

/// WorldTides (optional key) and NOAA CO-OPS (free, US stations).
class TidesApiClient {
  TidesApiClient({
    http.Client? httpClient,
    Duration? timeout,
    String? worldTidesApiKey,
  }) : _http = httpClient ?? http.Client(),
       _ownsHttpClient = httpClient == null,
       _timeout = timeout ?? const Duration(seconds: 18),
       _worldTidesApiKey =
           worldTidesApiKey ?? const String.fromEnvironment('WORLDTIDES_API_KEY');

  final http.Client _http;
  final bool _ownsHttpClient;
  final Duration _timeout;
  final String _worldTidesApiKey;

  void dispose() {
    if (_ownsHttpClient) {
      _http.close();
    }
  }

  /// Returns live HW/LW for the nearest station, or null when no provider applies.
  Future<TideDemoStation?> fetchTides(double lat, double lon) async {
    try {
      final noaa = await _fetchNoaa(lat, lon);
      if (noaa != null) return noaa;
    } catch (_) {}

    if (_worldTidesApiKey.isNotEmpty) {
      return _fetchWorldTides(lat, lon);
    }
    return null;
  }

  Future<TideDemoStation?> _fetchWorldTides(double lat, double lon) async {
    final uri = Uri.parse(
      'https://www.worldtides.info/api/v3'
      '?extremes'
      '&lat=${lat.toString()}'
      '&lon=${lon.toString()}'
      '&days=7'
      '&key=$_worldTidesApiKey',
    );
    final resp = await _http.get(uri).timeout(_timeout);
    if (resp.statusCode != 200) {
      throw HttpTidesException(resp.statusCode);
    }

    final map = jsonDecode(resp.body) as Map<String, dynamic>;
    if (map['status'] != 200) {
      throw HttpTidesException(map['status'] as int? ?? resp.statusCode);
    }

    final extremes = map['extremes'] as List<dynamic>? ?? const [];
    final events = <TideEvent>[];
    for (final raw in extremes) {
      if (raw is! Map<String, dynamic>) continue;
      final dt = raw['dt'];
      if (dt is! num) continue;
      final type = raw['type'] as String? ?? '';
      events.add(
        TideEvent(
          timeUtc: DateTime.fromMillisecondsSinceEpoch(
            (dt * 1000).round(),
            isUtc: true,
          ),
          heightM: (raw['height'] as num?)?.toDouble() ?? 0,
          isHigh: type.toLowerCase() == 'high',
        ),
      );
    }
    if (events.isEmpty) return null;

    events.sort((a, b) => a.timeUtc.compareTo(b.timeUtc));
    return TideDemoStation(
      stationName: 'WorldTides (${lat.toStringAsFixed(2)}, ${lon.toStringAsFixed(2)})',
      note: 'Heights from WorldTides.info — verify locally before navigation.',
      events: events,
    );
  }

  Future<TideDemoStation?> _fetchNoaa(double lat, double lon) async {
    final stationsUri = Uri.parse(
      'https://api.tidesandcurrents.noaa.gov/mdapi/prod/webapi/stations.json'
      '?type=tidepredictions'
      '&radius=120'
      '&units=metric'
      '&center=${lat.toString()},${lon.toString()}',
    );
    final stationsResp = await _http.get(stationsUri).timeout(_timeout);
    if (stationsResp.statusCode != 200) {
      throw HttpTidesException(stationsResp.statusCode);
    }

    final stationsMap = jsonDecode(stationsResp.body) as Map<String, dynamic>;
    final stations = stationsMap['stations'] as List<dynamic>? ?? const [];
    if (stations.isEmpty) return null;

    Map<String, dynamic>? nearest;
    var bestDist = double.infinity;
    for (final raw in stations) {
      if (raw is! Map<String, dynamic>) continue;
      final sLat = (raw['lat'] as num?)?.toDouble();
      final sLon = (raw['lng'] as num?)?.toDouble();
      if (sLat == null || sLon == null) continue;
      final d = Geolocator.distanceBetween(lat, lon, sLat, sLon);
      if (d < bestDist) {
        bestDist = d;
        nearest = raw;
      }
    }
    if (nearest == null) return null;

    final stationId = nearest['id']?.toString();
    if (stationId == null || stationId.isEmpty) return null;
    final stationName = nearest['name'] as String? ?? stationId;

    final now = DateTime.now().toUtc();
    final begin = _noaaDate(now);
    final end = _noaaDate(now.add(const Duration(days: 7)));
    final predUri = Uri.parse(
      'https://api.tidesandcurrents.noaa.gov/api/prod/dataservice/predictions'
      '?product=predictions'
      '&application=captain_wrongel'
      '&begin_date=$begin'
      '&end_date=$end'
      '&datum=MLLW'
      '&station=$stationId'
      '&time_zone=gmt'
      '&units=metric'
      '&interval=hilo'
      '&format=json',
    );
    final predResp = await _http.get(predUri).timeout(_timeout);
    if (predResp.statusCode != 200) {
      throw HttpTidesException(predResp.statusCode);
    }

    final predMap = jsonDecode(predResp.body) as Map<String, dynamic>;
    final predictions = predMap['predictions'] as List<dynamic>? ?? const [];
    final events = <TideEvent>[];
    for (final raw in predictions) {
      if (raw is! Map<String, dynamic>) continue;
      final t = raw['t'] as String?;
      final v = raw['v'] as String?;
      final type = raw['type'] as String?;
      if (t == null || v == null) continue;
      events.add(
        TideEvent(
          timeUtc: DateTime.parse('${t.replaceFirst(' ', 'T')}Z'),
          heightM: double.tryParse(v) ?? 0,
          isHigh: type == 'H',
        ),
      );
    }
    if (events.isEmpty) return null;

    events.sort((a, b) => a.timeUtc.compareTo(b.timeUtc));
    return TideDemoStation(
      stationName: 'NOAA $stationName',
      note: 'NOAA CO-OPS predictions (MLLW) — not for navigation without verification.',
      events: events,
    );
  }

  String _noaaDate(DateTime utc) {
    final d = utc.toUtc();
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y$m$day';
  }
}

class HttpTidesException implements Exception {
  HttpTidesException(this.statusCode);
  final int statusCode;

  @override
  String toString() => 'HTTP $statusCode';
}
