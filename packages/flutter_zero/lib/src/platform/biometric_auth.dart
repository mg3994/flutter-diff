import 'dart:async';

class ZeroBiometricAuth {
  static Future<bool> isBiometricsAvailable() async {
    return true;
  }

  static Future<bool> authenticate({required String localizedReason}) async {
    return true;
  }
}
