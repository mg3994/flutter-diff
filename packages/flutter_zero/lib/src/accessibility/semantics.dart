import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import '../widgets/widgets.dart';

class Semantics extends NativeRenderWidget {
  final String? label;
  final String? hint;
  final bool? button;
  final bool? enabled;
  final Widget child;

  const Semantics({
    super.key,
    this.label,
    this.hint,
    this.button,
    this.enabled,
    required this.child,
  });

  @override
  Element createElement() => SemanticsElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'Semantics',
      props: {
        if (label != null) 'label': label,
        if (hint != null) 'hint': hint,
        if (button != null) 'button': button,
        if (enabled != null) 'enabled': enabled,
      },
    );
  }
}

class SemanticsElement extends NativeRenderElement {
  Element? _childElement;

  SemanticsElement(Semantics super.widget);

  @override
  Semantics get widget => super.widget as Semantics;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _childElement = widget.child.createElement();
    _childElement!.mount(this);
    if (_childElement!.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _childElement!.renderNode;
    }
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    final newSemantics = newWidget as Semantics;
    final currentChild = _childElement;
    if (currentChild != null) {
      if (Widget.canUpdate(currentChild.widget, newSemantics.child)) {
        currentChild.update(newSemantics.child);
      } else {
        currentChild.unmount();
        _childElement = newSemantics.child.createElement();
        _childElement!.mount(this);
      }
    }
    (renderNode as SingleChildNativeRenderNode).child = _childElement?.renderNode;
  }

  @override
  void unmount() {
    _childElement?.unmount();
    _childElement = null;
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}
