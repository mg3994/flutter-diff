import '../backend/native_ui_backend.dart';
import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';

class FlutterZeroApp {
  final Widget rootWidget;
  final NativeUIBackend backend;

  RootElement? _rootElement;
  BoxConstraints _lastConstraints = const BoxConstraints(maxWidth: 800.0, maxHeight: 600.0);

  FlutterZeroApp({
    required this.rootWidget,
    required this.backend,
  });

  void run({BoxConstraints constraints = const BoxConstraints(maxWidth: 800.0, maxHeight: 600.0)}) {
    _lastConstraints = constraints;
    _rootElement = RootElement(rootWidget);
    _rootElement!.owner = this;
    _rootElement!.mountRoot();

    scheduleFrame();
  }

  void update(Widget newWidget, {BoxConstraints? constraints}) {
    if (_rootElement == null) return;
    if (constraints != null) _lastConstraints = constraints;
    _rootElement!.updateRoot(newWidget);
    scheduleFrame();
  }

  void scheduleFrame() {
    final rootRenderNode = _rootElement?.renderNode;
    if (rootRenderNode != null) {
      rootRenderNode.performLayout(_lastConstraints);
      _syncNativeTree(rootRenderNode, null);
    }
  }

  void _syncNativeTree(NativeRenderNode node, int? parentHandle) {
    final isNew = node.nativeHandle == null;
    if (isNew) {
      node.nativeHandle = backend.createView(node.widgetType, node.props);
    } else {
      backend.updateView(node.nativeHandle!, node.props);
    }

    backend.updateLayout(node.nativeHandle!, node.offset, node.size);

    if (isNew && parentHandle != null) {
      backend.appendChild(parentHandle, node.nativeHandle!);
    }

    if (isNew && node.onNativeHandleCreated != null) {
      node.onNativeHandleCreated!(node.nativeHandle!);
    }

    for (final child in node.children) {
      _syncNativeTree(child, node.nativeHandle);
    }
  }
}
