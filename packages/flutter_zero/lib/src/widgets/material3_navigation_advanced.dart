import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class NavigationDrawerDestination extends NativeRenderWidget {
  final Widget icon;
  final Widget label;
  final Widget? selectedIcon;

  const NavigationDrawerDestination({
    super.key,
    required this.icon,
    required this.label,
    this.selectedIcon,
  });

  @override
  Element createElement() => NavigationDrawerDestinationElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'NavigationDrawerDestination');
  }
}

class NavigationDrawerDestinationElement extends NativeRenderElement {
  Element? _iconEl;
  Element? _labelEl;

  NavigationDrawerDestinationElement(NavigationDrawerDestination super.widget);

  @override
  NavigationDrawerDestination get widget => super.widget as NavigationDrawerDestination;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    _iconEl = widget.icon.createElement()..mount(this);
    if (_iconEl?.renderNode != null) multiNode.addChild(_iconEl!.renderNode!);

    _labelEl = widget.label.createElement()..mount(this);
    if (_labelEl?.renderNode != null) multiNode.addChild(_labelEl!.renderNode!);
  }

  @override
  void unmount() {
    _iconEl?.unmount();
    _labelEl?.unmount();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_iconEl != null) visitor(_iconEl!);
    if (_labelEl != null) visitor(_labelEl!);
  }
}
