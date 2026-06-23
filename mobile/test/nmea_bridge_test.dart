import 'dart:async';
import 'dart:io';

import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/domain/ais/nmea_tcp_client.dart';
import 'package:captain_wrongel/features/ais/ais_nmea_preferences.dart';
import 'package:captain_wrongel/features/ais/ais_targets_provider.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('NmeaTcpClient emits buffered AIVDM lines from TCP feed', () async {
    final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(server.close);

    final fixture = await File('test/fixtures/nmea/sample_ais.log').readAsString();
    final line = fixture.trim();

    final serverSub = server.listen((client) async {
      client.write('$line\r\n');
      await client.flush();
    });
    addTearDown(serverSub.cancel);

    final client = NmeaTcpClient(
      host: InternetAddress.loopbackIPv4.address,
      port: server.port,
      reconnectDelay: const Duration(milliseconds: 50),
    );
    addTearDown(client.dispose);

    final lines = <String>[];
    final sub = client.lines.listen(lines.add);

    await client.start();
    await Future<void>.delayed(const Duration(milliseconds: 200));

    expect(lines, contains(line));
    await sub.cancel();
    await client.stop();
  });

  test('live NMEA bridge updates AIS targets from sample_ais.log', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());

    final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(server.close);

    final fixture = await File('test/fixtures/nmea/sample_ais.log').readAsString();
    final line = fixture.trim();

    final serverSub = server.listen((client) async {
      client.write('$line\n');
      await client.flush();
    });
    addTearDown(serverSub.cancel);

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(db),
        sessionIdProvider.overrideWithValue('test-session'),
        nmeaSocketConnectProvider.overrideWithValue(
          (host, port, {timeout}) => Socket.connect(host, port, timeout: timeout),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(aisNmeaPreferencesProvider.notifier)
        .setHost(InternetAddress.loopbackIPv4.address);
    await container.read(aisNmeaPreferencesProvider.notifier).setPort(server.port);

    await container
        .read(aisNmeaBridgeProvider.notifier)
        .setMode(AisNmeaSourceMode.live);

    await Future<void>.delayed(const Duration(milliseconds: 400));

    final targets = container.read(aisTargetsProvider);
    expect(targets, isNotEmpty);
    expect(targets.containsKey(227006760), isTrue);
    expect(targets[227006760]!.latitudeDeg, closeTo(34.02, 1e-5));

    await container
        .read(aisNmeaBridgeProvider.notifier)
        .setMode(AisNmeaSourceMode.off);
  });

  test('demo vs live toggle clears targets when switching off', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(db),
        sessionIdProvider.overrideWithValue('test-session'),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(aisNmeaBridgeProvider.notifier)
        .setMode(AisNmeaSourceMode.demo);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(container.read(aisTargetsProvider), isNotEmpty);

    await container
        .read(aisNmeaBridgeProvider.notifier)
        .setMode(AisNmeaSourceMode.off);
    expect(container.read(aisTargetsProvider), isEmpty);
    expect(container.read(aisNmeaBridgeProvider).mode, AisNmeaSourceMode.off);
  });
}
