import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class SliverFillViewport extends NativeRenderWidget {
  final List<Widget> children;
  final double viewportFraction;

  const SliverFillViewport({
    super.key,
    required this.children,
    this.viewportFraction = 1.0,
  });

  @override
  Element createElement() => SliverFillViewportElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'SliverFillViewport',
      props: {'viewportFraction': viewportFraction},
    );
  }
}

class SliverFillViewportElement extends NativeRenderElement {
  List<Element> _childElements = [];

  SliverFillViewportElement(SliverFillViewport super.widget);

  @override
  SliverFillViewport get widget => super.widget as SliverFillViewport;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    _childElements = widget.children.map((w) {
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
      return el;
    }).toList();
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
