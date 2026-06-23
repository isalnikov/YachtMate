import 'dart:async' show StreamController, StreamSubscription, Timer, unawaited;
import 'dart:convert';
import 'dart:io';

/// Connects to an NMEA 0183 TCP feed, emits complete lines, reconnects on drop.
typedef NmeaSocketConnect = Future<Socket> Function(
  String host,
  int port, {
  Duration? timeout,
});

class NmeaTcpClient {
  NmeaTcpClient({
    required this.host,
    required this.port,
    NmeaSocketConnect? connect,
    this.reconnectDelay = const Duration(seconds: 3),
    this.connectTimeout = const Duration(seconds: 8),
  }) : _connect = connect ?? Socket.connect;

  final String host;
  final int port;
  final NmeaSocketConnect _connect;
  final Duration reconnectDelay;
  final Duration connectTimeout;

  final StreamController<String> _linesController =
      StreamController<String>.broadcast();

  Stream<String> get lines => _linesController.stream;

  StreamSubscription<List<int>>? _socketSub;
  Socket? _socket;
  Timer? _reconnectTimer;
  var _running = false;
  var _buffer = '';

  bool get isRunning => _running;

  Future<void> start() async {
    if (_running) return;
    _running = true;
    await _connectOnce();
  }

  Future<void> stop() async {
    _running = false;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    await _socketSub?.cancel();
    _socketSub = null;
    _socket?.destroy();
    _socket = null;
    _buffer = '';
  }

  Future<void> dispose() async {
    await stop();
    await _linesController.close();
  }

  Future<void> _connectOnce() async {
    if (!_running) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    try {
      final socket = await _connect(host, port, timeout: connectTimeout);
      if (!_running) {
        socket.destroy();
        return;
      }
      _socket = socket;
      _buffer = '';
      _socketSub = socket.listen(
        _onBytes,
        onError: (_) => _scheduleReconnect(),
        onDone: _scheduleReconnect,
        cancelOnError: true,
      );
    } catch (_) {
      _scheduleReconnect();
    }
  }

  void _onBytes(List<int> bytes) {
    _buffer += utf8.decode(bytes, allowMalformed: true);
    final parts = _buffer.split(RegExp(r'\r?\n'));
    _buffer = parts.removeLast();
    for (final line in parts) {
      final trimmed = line.trim();
      if (trimmed.isNotEmpty) {
        _linesController.add(trimmed);
      }
    }
  }

  void _scheduleReconnect() {
    unawaited(_tearDownSocket());
    if (!_running) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(reconnectDelay, () {
      unawaited(_connectOnce());
    });
  }

  Future<void> _tearDownSocket() async {
    await _socketSub?.cancel();
    _socketSub = null;
    _socket?.destroy();
    _socket = null;
  }
}
