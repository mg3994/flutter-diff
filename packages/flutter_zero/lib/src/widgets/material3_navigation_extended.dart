import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class FloatingActionButtonExtended extends NativeRenderWidget {
  final Widget icon;
  final Widget label;
  final void Function()? onPressed;

  const FloatingActionButtonExtended({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Element createElement() => FloatingActionButtonExtendedElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'FloatingActionButtonExtended',
      props: {'enabled': onPressed != null},
    );
  }
}

class FloatingActionButtonExtendedElement extends NativeRenderElement {
  Element? _iconEl;
  Element? _labelEl;

  FloatingActionButtonExtendedElement(FloatingActionButtonExtended super.widget);

  @override
  FloatingActionButtonExtended get widget => super.widget as FloatingActionButtonExtended;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    _iconEl = widget.icon.createElement()..mount(this);
    if (_iconEl?.renderNode != null) multiNode.addChild(_iconEl!.renderNode!);

    _labelEl = widget.label.createElement()..mount(this);
    if (_labelEl?.renderNode != null) multiNode.addChild(_labelEl!.renderNode!);

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
  void unmount() {
    _iconEl?.unmount();
    _labelEl?.unmount();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_iconEl != null) visitor(_iconEl!);
    if (_labelEl != null) visitor(_labelEl!);
  }
}
