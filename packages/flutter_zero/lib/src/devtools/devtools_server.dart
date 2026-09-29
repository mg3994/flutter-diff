import 'dart:convert';
import '../backend/virtual_backend.dart';
import 'tree_inspector.dart';

class NativeDevToolsServer {
  final VirtualNativeUIBackend backend;
  bool _isRunning = false;

  NativeDevToolsServer({required this.backend});

  bool get isRunning => _isRunning;

  void start({int port = 8080}) {
    _isRunning = true;
  }

  void stop() {
    _isRunning = false;
  }

  String getSerializedRenderTree() {
    final inspector = NativeTreeInspector(backend);
    return jsonEncode(inspector.toJson());
  }
}
