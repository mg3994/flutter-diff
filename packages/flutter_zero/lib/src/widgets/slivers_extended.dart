import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

abstract class SliverGridDelegate {
  const SliverGridDelegate();
}

class SliverGridDelegateWithFixedCrossAxisCount extends SliverGridDelegate {
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  const SliverGridDelegateWithFixedCrossAxisCount({
    required this.crossAxisCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
  });
}

class SliverGridDelegateWithMaxCrossAxisExtent extends SliverGridDelegate {
  final double maxCrossAxisExtent;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  const SliverGridDelegateWithMaxCrossAxisExtent({
    required this.maxCrossAxisExtent,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
  });
}

class SliverFillRemaining extends NativeRenderWidget {
  final Widget child;

  const SliverFillRemaining({
    super.key,
    required this.child,
  });

  @override
  Element createElement() => SliverFillRemainingElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(widgetType: 'SliverFillRemaining');
  }
}

class SliverFillRemainingElement extends NativeRenderElement {
  Element? _childElement;

  SliverFillRemainingElement(SliverFillRemaining super.widget);

  @override
  SliverFillRemaining get widget => super.widget as SliverFillRemaining;

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
