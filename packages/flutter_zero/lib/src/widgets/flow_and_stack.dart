import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class IndexedStack extends NativeRenderWidget {
  final int index;
  final List<Widget> children;

  const IndexedStack({
    super.key,
    this.index = 0,
    this.children = const [],
  });

  @override
  Element createElement() => IndexedStackElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'IndexedStack',
      props: {'index': index},
    );
  }
}

class IndexedStackElement extends NativeRenderElement {
  List<Element> _childElements = [];

  IndexedStackElement(IndexedStack super.widget);

  @override
  IndexedStack get widget => super.widget as IndexedStack;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    _childElements = widget.children.map((w) {
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
      return el;
    }).toList();
  }

  @override
  void unmount() {
    for (final el in _childElements) {
      el.unmount();
    }
    _childElements.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    for (final el in _childElements) {
      visitor(el);
    }
  }
}

class Transform extends NativeRenderWidget {
  final Widget child;
  final double scale;
  final double rotation;

  const Transform({
    super.key,
    required this.child,
    this.scale = 1.0,
    this.rotation = 0.0,
  });

  const Transform.scale({
    super.key,
    required double scale,
    required this.child,
  })  : scale = scale,
        rotation = 0.0;

  const Transform.rotate({
    super.key,
    required double angle,
    required this.child,
  })  : rotation = angle,
        scale = 1.0;

  @override
  Element createElement() => TransformElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'Transform',
      props: {
        'scale': scale,
        'rotation': rotation,
      },
    );
  }
}

class TransformElement extends NativeRenderElement {
  Element? _childElement;

  TransformElement(Transform super.widget);

  @override
  Transform get widget => super.widget as Transform;

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
