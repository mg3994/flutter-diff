import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class GestureDetector extends NativeRenderWidget {
  final Widget child;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const GestureDetector({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
  });

  @override
  Element createElement() => GestureDetectorElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'GestureDetector',
      props: {
        'hasTap': onTap != null,
        'hasLongPress': onLongPress != null,
      },
    );
  }
}

class GestureDetectorElement extends NativeRenderElement {
  Element? _childElement;

  GestureDetectorElement(GestureDetector super.widget);

  @override
  GestureDetector get widget => super.widget as GestureDetector;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _childElement = widget.child.createElement();
    _childElement!.mount(this);
    if (_childElement!.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _childElement!.renderNode;
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
    if (backend != null) {
      if (widget.onTap != null) {
        backend.registerEventListener(handle, 'tap', (eventName, data) {
          widget.onTap?.call();
        });
      }
      if (widget.onLongPress != null) {
        backend.registerEventListener(handle, 'longPress', (eventName, data) {
          widget.onLongPress?.call();
        });
      }
    }
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    final newGestureDetector = newWidget as GestureDetector;
    final currentChild = _childElement;
    if (currentChild != null) {
      if (Widget.canUpdate(currentChild.widget, newGestureDetector.child)) {
        currentChild.update(newGestureDetector.child);
      } else {
        currentChild.unmount();
        _childElement = newGestureDetector.child.createElement();
        _childElement!.mount(this);
      }
    }
    (renderNode as SingleChildNativeRenderNode).child = _childElement?.renderNode;
    if (renderNode?.nativeHandle != null) {
      _registerEvents(renderNode!.nativeHandle!);
    }
  }

  @override
  void unmount() {
    _childElement?.unmount();
    _childElement = null;
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}
