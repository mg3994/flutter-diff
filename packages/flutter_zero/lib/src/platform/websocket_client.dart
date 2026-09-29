import 'dart:async';

class ZeroWebSocketClient {
  final String url;
  bool _isConnected = false;
  final StreamController<String> _streamController = StreamController<String>.broadcast();

  ZeroWebSocketClient({required this.url});

  bool get isConnected => _isConnected;
  Stream<String> get messages => _streamController.stream;

  Future<void> connect() async {
    _isConnected = true;
  }

  void send(String message) {
    if (_isConnected) {
      _streamController.add('echo: $message');
    }
  }

  Future<void> close() async {
    _isConnected = false;
    await _streamController.close();
  }
}
