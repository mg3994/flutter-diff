import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;

export 'package:intl/intl.dart';
export 'package:logger/logger.dart';

class ZeroIntl {
  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(date);
  }

  static String formatCurrency(num amount, {String symbol = '\$'}) {
    return NumberFormat.currency(symbol: symbol).format(amount);
  }
}

class ZeroLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  static void i(String message) => _logger.i(message);
  static void e(String message, [Object? error, StackTrace? stackTrace]) => _logger.e(message, error: error, stackTrace: stackTrace);
  static void w(String message) => _logger.w(message);
}

class ZeroPath {
  static String join(String part1, String part2, [String? part3, String? part4]) {
    if (part4 != null) return p.join(part1, part2, part3, part4);
    if (part3 != null) return p.join(part1, part2, part3);
    return p.join(part1, part2);
  }

  static String extension(String path) => p.extension(path);
  static String basename(String path) => p.basename(path);
}
