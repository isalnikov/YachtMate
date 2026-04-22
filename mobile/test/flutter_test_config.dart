import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:sqlite3/open.dart';

/// Drift + `sqlite3` FFI need a resolvable `libsqlite3` on Linux CI/dev hosts.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  if (Platform.isLinux) {
    open.overrideFor(OperatingSystem.linux, _openLinux);
  }
  await testMain();
}

DynamicLibrary _openLinux() {
  const candidates = <String>[
    '/usr/lib/x86_64-linux-gnu/libsqlite3.so',
    '/lib/x86_64-linux-gnu/libsqlite3.so.0',
    '/usr/lib/aarch64-linux-gnu/libsqlite3.so',
    '/lib/aarch64-linux-gnu/libsqlite3.so.0',
    'libsqlite3.so',
  ];
  Object? lastError;
  for (final path in candidates) {
    try {
      return DynamicLibrary.open(path);
    } catch (e) {
      lastError = e;
    }
  }
  throw StateError(
    'Could not load libsqlite3.so (install libsqlite3-0 / libsqlite3). Last: $lastError',
  );
}
