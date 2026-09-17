import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class SliverMainAxisGroup extends NativeRenderWidget {
  final List<Widget> slivers;

  const SliverMainAxisGroup({
    super.key,
    required this.slivers,
  });

  @override
  Element createElement() => SliverMainAxisGroupElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'SliverMainAxisGroup');
  }
}

class SliverMainAxisGroupElement extends NativeRenderElement {
  List<Element> _sliverEls = [];

  SliverMainAxisGroupElement(SliverMainAxisGroup super.widget);

  @override
  SliverMainAxisGroup get widget => super.widget as SliverMainAxisGroup;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    _sliverEls = widget.slivers.map((w) {
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
      return el;
    }).toList();
  }

  @override
  void unmount() {
    for (final el in _sliverEls) {
      el.unmount();
    }
    _sliverEls.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    for (final el in _sliverEls) {
      visitor(el);
    }
  }
}

class SliverCrossAxisGroup extends NativeRenderWidget {
  final List<Widget> slivers;

  const SliverCrossAxisGroup({
    super.key,
    required this.slivers,
  });

  @override
  Element createElement() => SliverCrossAxisGroupElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'SliverCrossAxisGroup');
  }
}

class SliverCrossAxisGroupElement extends NativeRenderElement {
  List<Element> _sliverEls = [];

  SliverCrossAxisGroupElement(SliverCrossAxisGroup super.widget);

  @override
  SliverCrossAxisGroup get widget => super.widget as SliverCrossAxisGroup;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    _sliverEls = widget.slivers.map((w) {
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
      return el;
    }).toList();
  }

  @override
  void unmount() {
    for (final el in _sliverEls) {
      el.unmount();
    }
    _sliverEls.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    for (final el in _sliverEls) {
      visitor(el);
    }
  }
}
