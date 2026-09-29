import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class InteractiveViewer extends NativeRenderWidget {
  final Widget child;
  final double minScale;
  final double maxScale;

  const InteractiveViewer({
    super.key,
    required this.child,
    this.minScale = 0.8,
    this.maxScale = 2.5,
  });

  @override
  Element createElement() => InteractiveViewerElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'InteractiveViewer',
      props: {
        'minScale': minScale,
        'maxScale': maxScale,
      },
    );
  }
}

class InteractiveViewerElement extends NativeRenderElement {
  Element? _childElement;

  InteractiveViewerElement(InteractiveViewer super.widget);

  @override
  InteractiveViewer get widget => super.widget as InteractiveViewer;

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

class BackdropFilter extends NativeRenderWidget {
  final Widget child;
  final double sigmaX;
  final double sigmaY;

  const BackdropFilter({
    super.key,
    required this.child,
    this.sigmaX = 10.0,
    this.sigmaY = 10.0,
  });

  @override
  Element createElement() => BackdropFilterElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'BackdropFilter',
      props: {
        'sigmaX': sigmaX,
        'sigmaY': sigmaY,
      },
    );
  }
}

class BackdropFilterElement extends NativeRenderElement {
  Element? _childElement;

  BackdropFilterElement(BackdropFilter super.widget);

  @override
  BackdropFilter get widget => super.widget as BackdropFilter;

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
