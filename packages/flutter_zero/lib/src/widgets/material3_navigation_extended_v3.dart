import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class DirectionalBadge extends NativeRenderWidget {
  final Widget? child;
  final String? label;

  const DirectionalBadge({
    super.key,
    this.child,
    this.label,
  });

  @override
  Element createElement() => DirectionalBadgeElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'DirectionalBadge',
      props: {if (label != null) 'label': label},
    );
  }
}

class DirectionalBadgeElement extends NativeRenderElement {
  Element? _childEl;

  DirectionalBadgeElement(DirectionalBadge super.widget);

  @override
  DirectionalBadge get widget => super.widget as DirectionalBadge;

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
