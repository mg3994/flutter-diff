import '../backend/native_ui_backend.dart';
import '../core/render_node.dart';

class WindowController {
  final NativeUIBackend backend;
  final int windowHandle;

  WindowController({
    required this.backend,
    required this.windowHandle,
  });

  void setSize(Size size) {
    backend.updateLayout(windowHandle, Offset.zero, size);
  }

  void setTitle(String title) {
    backend.updateView(windowHandle, {'title': title});
  }

  void close() {
    backend.removeView(windowHandle);
  }
}
