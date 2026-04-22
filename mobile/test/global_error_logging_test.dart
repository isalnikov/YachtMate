import 'package:captain_wrongel/core/logging/app_logger.dart';
import 'package:captain_wrongel/core/logging/global_error_logging.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('installGlobalErrorLogging does not throw', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    installGlobalErrorLogging(AppLogger('test'));
  });
}
