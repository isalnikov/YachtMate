import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_logger.dart';

const _maxStackChars = 32000;

String? _truncate(String? s, [int max = _maxStackChars]) {
  if (s == null) return null;
  if (s.length <= max) return s;
  return '${s.substring(0, max)}… [truncated ${s.length - max} chars]';
}

/// Registers framework and isolate-wide error sinks so failures surface in logs.
///
/// Call once after [WidgetsFlutterBinding.ensureInitialized], before [runApp].
/// Uses [developer.log] via [AppLogger]; safe field redaction applies in release.
void installGlobalErrorLogging(AppLogger log) {
  FlutterError.onError = (FlutterErrorDetails details) {
    try {
      log.error('flutter_framework', {
        'summary': details.summary.toString(),
        'exception': details.exceptionAsString(),
        if (details.library != null) 'library': details.library!,
        'stack': _truncate(details.stack?.toString()),
        if (details.silent) 'silent': true,
      });
    } catch (e, st) {
      debugPrint('global_error_logging: failed to log framework error: $e\n$st');
    }
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    try {
      log.error('uncaught_async', {
        'error': error.toString(),
        'stack': _truncate(stack.toString()),
      });
    } catch (e, st) {
      debugPrint('global_error_logging: failed to log async error: $e\n$st');
    }
    return false;
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    try {
      log.error('widget_build_failed', {
        'exception': details.exceptionAsString(),
        'stack': _truncate(details.stack?.toString()),
      });
    } catch (e, st) {
      debugPrint('global_error_logging: failed to log widget error: $e\n$st');
    }
    return ErrorWidget(details.exception);
  };
}

/// Logs when a Riverpod provider throws or a [Future]/[Stream] emits an error.
final class RiverpodErrorObserver extends ProviderObserver {
  RiverpodErrorObserver(this._log);

  final AppLogger _log;

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    try {
      _log.error('riverpod_provider_failed', {
        'provider': provider.name ?? provider.runtimeType.toString(),
        'error': error.toString(),
        'stack': _truncate(stackTrace.toString()),
      });
    } catch (e, st) {
      debugPrint('RiverpodErrorObserver failed: $e\n$st');
    }
  }
}
