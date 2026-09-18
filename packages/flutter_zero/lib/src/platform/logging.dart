import 'dart:async';

void dnLog(String message) {
  print('[dn] $message');
}

class DartNativeLogger {
  static void run(
    void Function() appRunner, {
    bool verbose = false,
    bool saveToFile = false,
  }) {
    runZonedGuarded(appRunner, (error, stack) {
      dnLog('Uncaught error: $error\n$stack');
    });
  }
}
