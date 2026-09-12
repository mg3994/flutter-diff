import '../backend/native_ui_backend.dart';
import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';

class FlutterZeroApp {
  final Widget rootWidget;
  final NativeUIBackend backend;

  RootElement? _rootElement;

  FlutterZeroApp({
    required this.rootWidget,
    required this.backend,
  });

  void run({BoxConstraints constraints = const BoxConstraints(maxWidth: 800.0, maxHeight: 600.0)}) {
    _rootElement = RootElement(rootWidget);
    _rootElement!.mountRoot();

    final rootRenderNode = _rootElement!.renderNode;
    if (rootRenderNode != null) {
      rootRenderNode.performLayout(constraints);
      _syncNativeTree(rootRenderNode, null);
    }
  }

  void update(Widget newWidget, {BoxConstraints constraints = const BoxConstraints(maxWidth: 800.0, maxHeight: 600.0)}) {
    if (_rootElement == null) return;
    _rootElement!.updateRoot(newWidget);

    final rootRenderNode = _rootElement!.renderNode;
    if (rootRenderNode != null) {
      rootRenderNode.performLayout(constraints);
      _syncNativeTree(rootRenderNode, null);
    }
  }

  void _syncNativeTree(NativeRenderNode node, int? parentHandle) {
    if (node.nativeHandle == null) {
      node.nativeHandle = backend.createView(node.widgetType, node.props);
    } else {
      backend.updateView(node.nativeHandle!, node.props);
    }

    backend.updateLayout(node.nativeHandle!, node.offset, node.size);

    if (parentHandle != null) {
      backend.appendChild(parentHandle, node.nativeHandle!);
    }

    for (final child in node.children) {
      _syncNativeTree(child, node.nativeHandle);
    }
  }
}
