import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

class FiLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (kDebugMode) {
      return true;
    }
    switch (event.level) {
      case Level.wtf:
      case Level.error:
      case Level.warning:
      case Level.info:
      case Level.debug:
        return true;
      default:
        return false;
    }
  }
}

class FiLog {
  final Logger _logger = Logger(
    filter: FiLogFilter(),
    // Use the default LogFilter (-> only log in debug mode)
    printer: PrettyPrinter(),
    // Use the PrettyPrinter to format and print log
    output: null, // Use the default LogOutput (-> send everything to console)v
  );

  get logger => _logger;
}

Logger logger = createLogger();

Logger createLogger() {
  return FiLog().logger;
}