import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class CupertinoPopupSurface extends NativeRenderWidget {
  final Widget? child;

  const CupertinoPopupSurface({
    super.key,
    this.child,
  });

  @override
  Element createElement() => CupertinoPopupSurfaceElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(widgetType: 'CupertinoPopupSurface');
  }
}

class CupertinoPopupSurfaceElement extends NativeRenderElement {
  Element? _childElement;

  CupertinoPopupSurfaceElement(CupertinoPopupSurface super.widget);

  @override
  CupertinoPopupSurface get widget => super.widget as CupertinoPopupSurface;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    if (widget.child != null) {
      _childElement = widget.child!.createElement()..mount(this);
      if (_childElement!.renderNode != null) {
        (renderNode as SingleChildNativeRenderNode).child = _childElement!.renderNode;
      }
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}
