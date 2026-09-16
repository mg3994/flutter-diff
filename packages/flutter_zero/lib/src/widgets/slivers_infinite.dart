import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

abstract class SliverChildDelegate {
  const SliverChildDelegate();
  Widget? build(BuildContext context, int index);
  int? get estimatedChildCount;
}

class SliverChildBuilderDelegate extends SliverChildDelegate {
  final Widget? Function(BuildContext context, int index) builder;
  final int? childCount;

  const SliverChildBuilderDelegate(
    this.builder, {
    this.childCount,
  });

  @override
  Widget? build(BuildContext context, int index) => builder(context, index);

  @override
  int? get estimatedChildCount => childCount;
}

class SliverChildListDelegate extends SliverChildDelegate {
  final List<Widget> children;

  const SliverChildListDelegate(this.children);

  @override
  Widget? build(BuildContext context, int index) {
    if (index >= 0 && index < children.length) {
      return children[index];
    }
    return null;
  }

  @override
  int? get estimatedChildCount => children.length;
}

typedef SliverLayoutWidgetBuilder = Widget Function(BuildContext context, BoxConstraints constraints);

class SliverLayoutBuilder extends NativeRenderWidget {
  final SliverLayoutWidgetBuilder builder;

  const SliverLayoutBuilder({
    super.key,
    required this.builder,
  });

  @override
  Element createElement() => SliverLayoutBuilderElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(widgetType: 'SliverLayoutBuilder');
  }
}

class SliverLayoutBuilderElement extends NativeRenderElement {
  Element? _childEl;

  SliverLayoutBuilderElement(SliverLayoutBuilder super.widget);

  @override
  SliverLayoutBuilder get widget => super.widget as SliverLayoutBuilder;

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
