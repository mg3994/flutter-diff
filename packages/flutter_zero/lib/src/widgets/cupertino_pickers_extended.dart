import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class CupertinoPicker extends NativeRenderWidget {
  final double itemExtent;
  final void Function(int index)? onSelectedItemChanged;
  final List<Widget> children;

  const CupertinoPicker({
    super.key,
    required this.itemExtent,
    required this.onSelectedItemChanged,
    required this.children,
  });

  @override
  Element createElement() => CupertinoPickerElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'CupertinoPicker',
      props: {'itemExtent': itemExtent},
    );
  }
}

class CupertinoPickerElement extends NativeRenderElement {
  List<Element> _childElements = [];

  CupertinoPickerElement(CupertinoPicker super.widget);

  @override
  CupertinoPicker get widget => super.widget as CupertinoPicker;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    _childElements = widget.children.map((w) {
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
      return el;
    }).toList();

    renderNode?.onNativeHandleCreated = (handle) {
      _registerEvents(handle);
    };
    if (renderNode?.nativeHandle != null) {
      _registerEvents(renderNode!.nativeHandle!);
    }
  }

  void _registerEvents(int handle) {
    final backend = appOwner?.backend;
    if (backend != null && widget.onSelectedItemChanged != null) {
      backend.registerEventListener(handle, 'select', (name, data) {
        final index = (data['index'] as num?)?.toInt() ?? 0;
        widget.onSelectedItemChanged?.call(index);
      });
    }
  }

  @override
  void unmount() {
    for (final el in _childElements) {
      el.unmount();
    }
    _childElements.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    for (final el in _childElements) {
      visitor(el);
    }
  }
}
