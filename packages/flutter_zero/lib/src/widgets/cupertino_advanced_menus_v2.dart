import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class CupertinoListSectionInsetGrouped extends NativeRenderWidget {
  final List<Widget> children;
  final Widget? header;

  const CupertinoListSectionInsetGrouped({
    super.key,
    required this.children,
    this.header,
  });

  @override
  Element createElement() => CupertinoListSectionInsetGroupedElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'CupertinoListSectionInsetGrouped',
    );
  }
}

class CupertinoListSectionInsetGroupedElement extends NativeRenderElement {
  Element? _headerEl;
  List<Element> _childEls = [];

  CupertinoListSectionInsetGroupedElement(CupertinoListSectionInsetGrouped super.widget);

  @override
  CupertinoListSectionInsetGrouped get widget => super.widget as CupertinoListSectionInsetGrouped;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    if (widget.header != null) {
      _headerEl = widget.header!.createElement()..mount(this);
      if (_headerEl?.renderNode != null) multiNode.addChild(_headerEl!.renderNode!);
    }

    _childEls = widget.children.map((w) {
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
      return el;
    }).toList();
  }

  @override
  void unmount() {
    _headerEl?.unmount();
    for (final el in _childEls) {
      el.unmount();
    }
    _childEls.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_headerEl != null) visitor(_headerEl!);
    for (final el in _childEls) {
      visitor(el);
    }
  }
}
