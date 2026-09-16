import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

typedef FastListItemBuilder = Widget Function(BuildContext context, int index);

class FastList extends NativeRenderWidget {
  final int itemCount;
  final double itemExtent;
  final FastListItemBuilder itemBuilder;

  const FastList({
    super.key,
    required this.itemCount,
    this.itemExtent = 60.0,
    required this.itemBuilder,
  });

  @override
  Element createElement() => FastListElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return FastListRenderNode(
      props: {
        'itemCount': itemCount,
        'itemExtent': itemExtent,
      },
    );
  }
}

class FastListRenderNode extends MultiChildNativeRenderNode {
  FastListRenderNode({required super.props}) : super(widgetType: 'FastList');

  @override
  void performLayout(BoxConstraints constraints) {
    final double itemExtent = (props['itemExtent'] as num?)?.toDouble() ?? 60.0;
    final int itemCount = (props['itemCount'] as num?)?.toInt() ?? 0;
    size = constraints.constrain(Size(
      constraints.maxWidth.isFinite ? constraints.maxWidth : 300.0,
      itemCount * itemExtent,
    ));
  }
}

class FastListElement extends NativeRenderElement {
  List<Element> _childElements = [];

  FastListElement(FastList super.widget);

  @override
  FastList get widget => super.widget as FastList;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    _childElements = List.generate(widget.itemCount, (i) {
      final w = widget.itemBuilder(this, i);
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
      return el;
    });
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

class FastGrid extends NativeRenderWidget {
  final int itemCount;
  final int crossAxisCount;
  final double itemHeight;
  final FastListItemBuilder itemBuilder;

  const FastGrid({
    super.key,
    required this.itemCount,
    this.crossAxisCount = 2,
    this.itemHeight = 100.0,
    required this.itemBuilder,
  });

  @override
  Element createElement() => FastGridElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'FastGrid',
      props: {
        'itemCount': itemCount,
        'crossAxisCount': crossAxisCount,
        'itemHeight': itemHeight,
      },
    );
  }
}

class FastGridElement extends NativeRenderElement {
  List<Element> _childElements = [];

  FastGridElement(FastGrid super.widget);

  @override
  FastGrid get widget => super.widget as FastGrid;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    _childElements = List.generate(widget.itemCount, (i) {
      final w = widget.itemBuilder(this, i);
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
      return el;
    });
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

class MasonryFastGrid extends NativeRenderWidget {
  final int itemCount;
  final int crossAxisCount;
  final FastListItemBuilder itemBuilder;

  const MasonryFastGrid({
    super.key,
    required this.itemCount,
    this.crossAxisCount = 2,
    required this.itemBuilder,
  });

  @override
  Element createElement() => MasonryFastGridElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'MasonryFastGrid',
      props: {
        'itemCount': itemCount,
        'crossAxisCount': crossAxisCount,
      },
    );
  }
}

class MasonryFastGridElement extends NativeRenderElement {
  List<Element> _childElements = [];

  MasonryFastGridElement(MasonryFastGrid super.widget);

  @override
  MasonryFastGrid get widget => super.widget as MasonryFastGrid;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    _childElements = List.generate(widget.itemCount, (i) {
      final w = widget.itemBuilder(this, i);
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
      return el;
    });
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
