import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class GridView extends NativeRenderWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  const GridView({
    super.key,
    this.children = const [],
    required this.crossAxisCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
  });

  @override
  Element createElement() => GridViewElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return GridViewRenderNode(
      props: {
        'crossAxisCount': crossAxisCount,
        'mainAxisSpacing': mainAxisSpacing,
        'crossAxisSpacing': crossAxisSpacing,
        'childAspectRatio': childAspectRatio,
      },
    );
  }
}

class GridViewRenderNode extends MultiChildNativeRenderNode {
  GridViewRenderNode({required super.props}) : super(widgetType: 'GridView');

  @override
  void performLayout(BoxConstraints constraints) {
    final int crossAxisCount = props['crossAxisCount'] as int? ?? 2;
    final double mainAxisSpacing = (props['mainAxisSpacing'] as num?)?.toDouble() ?? 0.0;
    final double crossAxisSpacing = (props['crossAxisSpacing'] as num?)?.toDouble() ?? 0.0;
    final double childAspectRatio = (props['childAspectRatio'] as num?)?.toDouble() ?? 1.0;

    final double availableWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : 800.0;
    final double totalCrossSpacing = crossAxisSpacing * (crossAxisCount - 1);
    final double itemWidth = (availableWidth - totalCrossSpacing) / crossAxisCount;
    final double itemHeight = itemWidth / (childAspectRatio > 0 ? childAspectRatio : 1.0);

    double currentY = 0.0;

    for (int i = 0; i < children.length; i++) {
      final child = children[i];
      final int col = i % crossAxisCount;
      final int row = i ~/ crossAxisCount;

      final double x = col * (itemWidth + crossAxisSpacing);
      final double y = row * (itemHeight + mainAxisSpacing);

      child.performLayout(BoxConstraints(
        minWidth: itemWidth,
        maxWidth: itemWidth,
        minHeight: itemHeight,
        maxHeight: itemHeight,
      ));
      child.offset = Offset(x, y);

      currentY = y + itemHeight;
    }

    size = constraints.constrain(Size(availableWidth, currentY));
  }
}

class GridViewElement extends NativeRenderElement {
  List<Element> _childElements = [];

  GridViewElement(GridView super.widget);

  @override
  GridView get widget => super.widget as GridView;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;
    _childElements = widget.children.map((w) {
      final el = w.createElement();
      el.mount(this);
      if (el.renderNode != null) {
        multiNode.addChild(el.renderNode!);
      }
      return el;
    }).toList();
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    final newGridView = newWidget as GridView;
    final multiNode = renderNode as MultiChildNativeRenderNode;
    final newChildrenWidgets = newGridView.children;

    final List<Element> newChildElements = [];
    multiNode.children.clear();

    final int minLength = _childElements.length < newChildrenWidgets.length
        ? _childElements.length
        : newChildrenWidgets.length;

    for (int i = 0; i < minLength; i++) {
      final oldEl = _childElements[i];
      final newW = newChildrenWidgets[i];
      if (Widget.canUpdate(oldEl.widget, newW)) {
        oldEl.update(newW);
        newChildElements.add(oldEl);
      } else {
        oldEl.unmount();
        final newEl = newW.createElement();
        newEl.mount(this);
        newChildElements.add(newEl);
      }
    }

    if (_childElements.length > newChildrenWidgets.length) {
      for (int i = minLength; i < _childElements.length; i++) {
        _childElements[i].unmount();
      }
    } else if (newChildrenWidgets.length > _childElements.length) {
      for (int i = minLength; i < newChildrenWidgets.length; i++) {
        final newEl = newChildrenWidgets[i].createElement();
        newEl.mount(this);
        newChildElements.add(newEl);
      }
    }

    _childElements = newChildElements;
    for (final el in _childElements) {
      if (el.renderNode != null) {
        multiNode.addChild(el.renderNode!);
      }
    }
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
