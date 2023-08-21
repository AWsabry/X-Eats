import 'package:logger/logger.dart';

class AppLogger {
  static final _logger = Logger(
    level: Level.debug, // Set the minimum level to log
    printer: PrettyPrinter(), // Use a pretty printer for log messages
  );

  static void d(String message) {
    _logger.d(message);
  }

  static void i(String message) {
    _logger.i(message);
  }

  static void w(String message) {
    _logger.w(message);
  }

  static void e(String message) {
    _logger.e(message);
  }
}
