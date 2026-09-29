import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class ElevatedCard extends NativeRenderWidget {
  final Widget? child;
  final double elevation;

  const ElevatedCard({
    super.key,
    this.child,
    this.elevation = 2.0,
  });

  @override
  Element createElement() => ElevatedCardElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'ElevatedCard',
      props: {'elevation': elevation},
    );
  }
}

class ElevatedCardElement extends NativeRenderElement {
  Element? _childElement;

  ElevatedCardElement(ElevatedCard super.widget);

  @override
  ElevatedCard get widget => super.widget as ElevatedCard;

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

class OutlinedCard extends NativeRenderWidget {
  final Widget? child;

  const OutlinedCard({
    super.key,
    this.child,
  });

  @override
  Element createElement() => OutlinedCardElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(widgetType: 'OutlinedCard');
  }
}

class OutlinedCardElement extends NativeRenderElement {
  Element? _childElement;

  OutlinedCardElement(OutlinedCard super.widget);

  @override
  OutlinedCard get widget => super.widget as OutlinedCard;

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

class Tooltip extends NativeRenderWidget {
  final String message;
  final Widget child;

  const Tooltip({
    super.key,
    required this.message,
    required this.child,
  });

  @override
  Element createElement() => TooltipElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'Tooltip',
      props: {'message': message},
    );
  }
}

class TooltipElement extends NativeRenderElement {
  Element? _childElement;

  TooltipElement(Tooltip super.widget);

  @override
  Tooltip get widget => super.widget as Tooltip;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _childElement = widget.child.createElement()..mount(this);
    if (_childElement!.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _childElement!.renderNode;
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}
