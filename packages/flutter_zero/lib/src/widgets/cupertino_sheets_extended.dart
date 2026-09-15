import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class CupertinoTabScaffold extends NativeRenderWidget {
  final Widget tabBar;
  final Widget Function(BuildContext context, int index) tabBuilder;

  const CupertinoTabScaffold({
    super.key,
    required this.tabBar,
    required this.tabBuilder,
  });

  @override
  Element createElement() => CupertinoTabScaffoldElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'CupertinoTabScaffold');
  }
}

class CupertinoTabScaffoldElement extends NativeRenderElement {
  Element? _tabBarEl;
  Element? _tabBodyEl;

  CupertinoTabScaffoldElement(CupertinoTabScaffold super.widget);

  @override
  CupertinoTabScaffold get widget => super.widget as CupertinoTabScaffold;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    _tabBarEl = widget.tabBar.createElement()..mount(this);
    if (_tabBarEl?.renderNode != null) multiNode.addChild(_tabBarEl!.renderNode!);

    final bodyWidget = widget.tabBuilder(this, 0);
    _tabBodyEl = bodyWidget.createElement()..mount(this);
    if (_tabBodyEl?.renderNode != null) multiNode.addChild(_tabBodyEl!.renderNode!);
  }

  @override
  void unmount() {
    _tabBarEl?.unmount();
    _tabBodyEl?.unmount();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_tabBarEl != null) visitor(_tabBarEl!);
    if (_tabBodyEl != null) visitor(_tabBodyEl!);
  }
}
