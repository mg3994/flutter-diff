import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class Material3Badge extends NativeRenderWidget {
  final Widget? child;
  final String? label;
  final int? count;

  const Material3Badge({
    super.key,
    this.child,
    this.label,
    this.count,
  });

  const Material3Badge.count({
    super.key,
    required int count,
    this.child,
  })  : count = count,
        label = null;

  @override
  Element createElement() => Material3BadgeElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'Material3Badge',
      props: {
        if (label != null) 'label': label,
        if (count != null) 'count': count,
      },
    );
  }
}

class Material3BadgeElement extends NativeRenderElement {
  Element? _childEl;

  Material3BadgeElement(Material3Badge super.widget);

  @override
  Material3Badge get widget => super.widget as Material3Badge;

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
