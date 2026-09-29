import 'dart:async';

enum ZeroConnectivityResult { wifi, mobile, none }

class ZeroConnectivity {
  static final StreamController<ZeroConnectivityResult> _statusController = StreamController<ZeroConnectivityResult>.broadcast();

  static Stream<ZeroConnectivityResult> get onConnectivityChanged => _statusController.stream;

  static Future<ZeroConnectivityResult> checkConnectivity() async {
    return ZeroConnectivityResult.wifi;
  }
}
