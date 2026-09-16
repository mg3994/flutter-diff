import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class SecondaryTabController {
  int index;

  SecondaryTabController({this.index = 0});
}

class SecondaryTabBar extends NativeRenderWidget {
  final List<Widget> tabs;

  const SecondaryTabBar({
    super.key,
    required this.tabs,
  });

  @override
  Element createElement() => SecondaryTabBarElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'SecondaryTabBar');
  }
}

class SecondaryTabBarElement extends NativeRenderElement {
  List<Element> _tabEls = [];

  SecondaryTabBarElement(SecondaryTabBar super.widget);

  @override
  SecondaryTabBar get widget => super.widget as SecondaryTabBar;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    _tabEls = widget.tabs.map((w) {
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
      return el;
    }).toList();
  }

  @override
  void unmount() {
    for (final el in _tabEls) {
      el.unmount();
    }
    _tabEls.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    for (final el in _tabEls) {
      visitor(el);
    }
  }
}
