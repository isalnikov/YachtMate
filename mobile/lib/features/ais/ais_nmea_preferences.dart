import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers.dart';

/// TCP endpoint for a local AIS/NMEA Wi‑Fi gateway (Step 46).
class AisNmeaEndpoint {
  const AisNmeaEndpoint({required this.host, required this.port});

  final String host;
  final int port;

  AisNmeaEndpoint copyWith({String? host, int? port}) {
    return AisNmeaEndpoint(
      host: host ?? this.host,
      port: port ?? this.port,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AisNmeaEndpoint &&
      other.host == host &&
      other.port == port;

  @override
  int get hashCode => Object.hash(host, port);
}

class AisNmeaPreferencesNotifier extends StateNotifier<AisNmeaEndpoint> {
  AisNmeaPreferencesNotifier(this._ref)
    : super(_initial(_ref.read(sharedPreferencesProvider)));

  final Ref _ref;

  static const _hostKey = 'ais_nmea_host';
  static const _portKey = 'ais_nmea_port';
  static const defaultHost = '192.168.4.1';
  static const defaultPort = 10110;

  static AisNmeaEndpoint _initial(SharedPreferences prefs) {
    return AisNmeaEndpoint(
      host: prefs.getString(_hostKey) ?? defaultHost,
      port: prefs.getInt(_portKey) ?? defaultPort,
    );
  }

  Future<void> setHost(String host) async {
    final trimmed = host.trim();
    if (trimmed.isEmpty || trimmed == state.host) return;
    await _ref.read(sharedPreferencesProvider).setString(_hostKey, trimmed);
    state = state.copyWith(host: trimmed);
  }

  Future<void> setPort(int port) async {
    if (port <= 0 || port > 65535 || port == state.port) return;
    await _ref.read(sharedPreferencesProvider).setInt(_portKey, port);
    state = state.copyWith(port: port);
  }

  /// Persists host/port from text fields (step 64 — before Live connect).
  Future<void> applyFromFields(String host, String portText) async {
    final trimmedHost = host.trim();
    if (trimmedHost.isNotEmpty) {
      await setHost(trimmedHost);
    }
    final port = int.tryParse(portText.trim());
    if (port != null) {
      await setPort(port);
    }
  }
}

final aisNmeaPreferencesProvider =
    StateNotifierProvider<AisNmeaPreferencesNotifier, AisNmeaEndpoint>(
      (ref) => AisNmeaPreferencesNotifier(ref),
    );
