import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class OverlayEntry {
  final Widget Function(BuildContext context) builder;
  bool _mounted = true;

  OverlayEntry({required this.builder});

  void remove() {
    _mounted = false;
  }
}

class Overlay extends NativeRenderWidget {
  final List<OverlayEntry> initialEntries;

  const Overlay({
    super.key,
    this.initialEntries = const [],
  });

  @override
  Element createElement() => OverlayElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'Overlay');
  }
}

class OverlayElement extends NativeRenderElement {
  List<Element> _entryEls = [];

  OverlayElement(Overlay super.widget);

  @override
  Overlay get widget => super.widget as Overlay;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    for (final entry in widget.initialEntries) {
      if (entry._mounted) {
        final w = entry.builder(this);
        final el = w.createElement()..mount(this);
        if (el.renderNode != null) multiNode.addChild(el.renderNode!);
        _entryEls.add(el);
      }
    }
  }

  @override
  void unmount() {
    for (final el in _entryEls) {
      el.unmount();
    }
    _entryEls.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    for (final el in _entryEls) {
      visitor(el);
    }
  }
}
