import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class SlideTransition extends NativeRenderWidget {
  final Widget child;
  final Offset position;

  const SlideTransition({
    super.key,
    required this.child,
    this.position = Offset.zero,
  });

  @override
  Element createElement() => SlideTransitionElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'SlideTransition',
      props: {
        'dx': position.dx,
        'dy': position.dy,
      },
    );
  }
}

class SlideTransitionElement extends NativeRenderElement {
  Element? _childEl;

  SlideTransitionElement(SlideTransition super.widget);

  @override
  SlideTransition get widget => super.widget as SlideTransition;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _childEl = widget.child.createElement()..mount(this);
    if (_childEl?.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _childEl!.renderNode;
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childEl != null) visitor(_childEl!);
  }
}

class ScaleTransition extends NativeRenderWidget {
  final Widget child;
  final double scale;

  const ScaleTransition({
    super.key,
    required this.child,
    this.scale = 1.0,
  });

  @override
  Element createElement() => ScaleTransitionElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'ScaleTransition',
      props: {'scale': scale},
    );
  }
}

class ScaleTransitionElement extends NativeRenderElement {
  Element? _childEl;

  ScaleTransitionElement(ScaleTransition super.widget);

  @override
  ScaleTransition get widget => super.widget as ScaleTransition;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _childEl = widget.child.createElement()..mount(this);
    if (_childEl?.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _childEl!.renderNode;
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childEl != null) visitor(_childEl!);
  }
}

class RotationTransition extends NativeRenderWidget {
  final Widget child;
  final double turns;

  const RotationTransition({
    super.key,
    required this.child,
    this.turns = 0.0,
  });

  @override
  Element createElement() => RotationTransitionElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'RotationTransition',
      props: {'turns': turns},
    );
  }
}

class RotationTransitionElement extends NativeRenderElement {
  Element? _childEl;

  RotationTransitionElement(RotationTransition super.widget);

  @override
  RotationTransition get widget => super.widget as RotationTransition;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _childEl = widget.child.createElement()..mount(this);
    if (_childEl?.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _childEl!.renderNode;
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childEl != null) visitor(_childEl!);
  }
}
