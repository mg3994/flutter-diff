import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class BadgeCount extends NativeRenderWidget {
  final int count;
  final Widget? child;

  const BadgeCount({
    super.key,
    required this.count,
    this.child,
  });

  @override
  Element createElement() => BadgeCountElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'BadgeCount',
      props: {'count': count},
    );
  }
}

class BadgeCountElement extends NativeRenderElement {
  Element? _childEl;

  BadgeCountElement(BadgeCount super.widget);

  @override
  BadgeCount get widget => super.widget as BadgeCount;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    if (widget.child != null) {
      _childEl = widget.child!.createElement()..mount(this);
      if (_childEl?.renderNode != null) {
        (renderNode as SingleChildNativeRenderNode).child = _childEl!.renderNode;
      }
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childEl != null) visitor(_childEl!);
  }
}
