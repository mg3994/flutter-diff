import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class FloatingActionButtonLarge extends NativeRenderWidget {
  final Widget child;
  final void Function()? onPressed;

  const FloatingActionButtonLarge({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Element createElement() => FloatingActionButtonLargeElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'FloatingActionButtonLarge',
      props: {'enabled': onPressed != null},
    );
  }
}

class FloatingActionButtonLargeElement extends NativeRenderElement {
  Element? _childEl;

  FloatingActionButtonLargeElement(FloatingActionButtonLarge super.widget);

  @override
  FloatingActionButtonLarge get widget => super.widget as FloatingActionButtonLarge;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _childEl = widget.child.createElement()..mount(this);
    if (_childEl?.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _childEl!.renderNode;
    }

    renderNode?.onNativeHandleCreated = (handle) {
      _registerEvents(handle);
    };
    if (renderNode?.nativeHandle != null) {
      _registerEvents(renderNode!.nativeHandle!);
    }
  }

  void _registerEvents(int handle) {
    final backend = appOwner?.backend;
    if (backend != null && widget.onPressed != null) {
      backend.registerEventListener(handle, 'click', (name, data) {
        widget.onPressed?.call();
      });
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childEl != null) visitor(_childEl!);
  }
}
