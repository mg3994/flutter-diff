import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

typedef LayoutWidgetBuilder = Widget Function(BuildContext context, BoxConstraints constraints);

class LayoutBuilder extends NativeRenderWidget {
  final LayoutWidgetBuilder builder;

  const LayoutBuilder({
    super.key,
    required this.builder,
  });

  @override
  Element createElement() => LayoutBuilderElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return LayoutBuilderRenderNode(builder: builder);
  }
}

class LayoutBuilderRenderNode extends SingleChildNativeRenderNode {
  final LayoutWidgetBuilder builder;

  LayoutBuilderRenderNode({required this.builder})
      : super(widgetType: 'LayoutBuilder');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(Size(
      constraints.maxWidth.isFinite ? constraints.maxWidth : 300.0,
      constraints.maxHeight.isFinite ? constraints.maxHeight : 300.0,
    ));
  }
}

class LayoutBuilderElement extends NativeRenderElement {
  Element? _childEl;

  LayoutBuilderElement(LayoutBuilder super.widget);

  @override
  LayoutBuilder get widget => super.widget as LayoutBuilder;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final builtWidget = widget.builder(this, const BoxConstraints(maxWidth: 800, maxHeight: 600));
    _childEl = builtWidget.createElement()..mount(this);
    if (_childEl?.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _childEl!.renderNode;
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childEl != null) visitor(_childEl!);
  }
}

enum Orientation { portrait, landscape }

typedef OrientationWidgetBuilder = Widget Function(BuildContext context, Orientation orientation);

class OrientationBuilder extends NativeRenderWidget {
  final OrientationWidgetBuilder builder;

  const OrientationBuilder({
    super.key,
    required this.builder,
  });

  @override
  Element createElement() => OrientationBuilderElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(widgetType: 'OrientationBuilder');
  }
}

class OrientationBuilderElement extends NativeRenderElement {
  Element? _childEl;

  OrientationBuilderElement(OrientationBuilder super.widget);

  @override
  OrientationBuilder get widget => super.widget as OrientationBuilder;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final builtWidget = widget.builder(this, Orientation.portrait);
    _childEl = builtWidget.createElement()..mount(this);
    if (_childEl?.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _childEl!.renderNode;
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childEl != null) visitor(_childEl!);
  }
}
