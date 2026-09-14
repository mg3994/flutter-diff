import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

abstract class SliverWidget extends NativeRenderWidget {
  const SliverWidget({super.key});
}

class SliverList extends SliverWidget {
  final List<Widget> children;

  const SliverList({
    super.key,
    this.children = const [],
  });

  @override
  Element createElement() => SliverListElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SliverListRenderNode();
  }
}

class SliverListRenderNode extends MultiChildNativeRenderNode {
  SliverListRenderNode() : super(widgetType: 'SliverList');

  @override
  void performLayout(BoxConstraints constraints) {
    double totalHeight = 0.0;
    double maxWidth = 0.0;

    for (final child in children) {
      child.performLayout(constraints);
      child.offset = Offset(0, totalHeight);
      totalHeight += child.size.height;
      if (child.size.width > maxWidth) maxWidth = child.size.width;
    }

    size = constraints.constrain(Size(maxWidth, totalHeight));
  }
}

class SliverListElement extends NativeRenderElement {
  List<Element> _childElements = [];

  SliverListElement(SliverList super.widget);

  @override
  SliverList get widget => super.widget as SliverList;

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
    final newSliverList = newWidget as SliverList;
    final multiNode = renderNode as MultiChildNativeRenderNode;
    final newChildrenWidgets = newSliverList.children;

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

class SliverGrid extends SliverWidget {
  final List<Widget> children;
  final int crossAxisCount;

  const SliverGrid({
    super.key,
    this.children = const [],
    this.crossAxisCount = 2,
  });

  @override
  Element createElement() => SliverGridElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'SliverGrid',
      props: {'crossAxisCount': crossAxisCount},
    );
  }
}

class SliverGridElement extends NativeRenderElement {
  List<Element> _childElements = [];

  SliverGridElement(SliverGrid super.widget);

  @override
  SliverGrid get widget => super.widget as SliverGrid;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _childElements = widget.children.map((w) {
      final el = w.createElement();
      el.mount(this);
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

class SliverToBoxAdapter extends SliverWidget {
  final Widget? child;

  const SliverToBoxAdapter({
    super.key,
    this.child,
  });

  @override
  Element createElement() => SliverToBoxAdapterElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(widgetType: 'SliverToBoxAdapter');
  }
}

class SliverToBoxAdapterElement extends NativeRenderElement {
  Element? _childElement;

  SliverToBoxAdapterElement(SliverToBoxAdapter super.widget);

  @override
  SliverToBoxAdapter get widget => super.widget as SliverToBoxAdapter;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    if (widget.child != null) {
      _childElement = widget.child!.createElement();
      _childElement!.mount(this);
    }
  }

  @override
  void unmount() {
    _childElement?.unmount();
    _childElement = null;
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}

class SliverAppBar extends SliverWidget {
  final Widget? title;
  final bool pinned;
  final bool expanded;

  const SliverAppBar({
    super.key,
    this.title,
    this.pinned = false,
    this.expanded = false,
  });

  @override
  Element createElement() => SliverAppBarElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'SliverAppBar',
      props: {'pinned': pinned, 'expanded': expanded},
    );
  }
}

class SliverAppBarElement extends NativeRenderElement {
  Element? _titleElement;

  SliverAppBarElement(SliverAppBar super.widget);

  @override
  SliverAppBar get widget => super.widget as SliverAppBar;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    if (widget.title != null) {
      _titleElement = widget.title!.createElement();
      _titleElement!.mount(this);
    }
  }

  @override
  void unmount() {
    _titleElement?.unmount();
    _titleElement = null;
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_titleElement != null) visitor(_titleElement!);
  }
}

class CustomScrollView extends NativeRenderWidget {
  final List<Widget> slivers;

  const CustomScrollView({
    super.key,
    this.slivers = const [],
  });

  @override
  Element createElement() => CustomScrollViewElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return CustomScrollViewRenderNode();
  }
}

class CustomScrollViewRenderNode extends MultiChildNativeRenderNode {
  CustomScrollViewRenderNode() : super(widgetType: 'CustomScrollView');

  @override
  void performLayout(BoxConstraints constraints) {
    double totalHeight = 0.0;
    double maxWidth = 0.0;

    for (final child in children) {
      child.performLayout(constraints);
      child.offset = Offset(0, totalHeight);
      totalHeight += child.size.height;
      if (child.size.width > maxWidth) maxWidth = child.size.width;
    }

    size = constraints.constrain(Size(maxWidth, totalHeight));
  }
}

class CustomScrollViewElement extends NativeRenderElement {
  List<Element> _childElements = [];

  CustomScrollViewElement(CustomScrollView super.widget);

  @override
  CustomScrollView get widget => super.widget as CustomScrollView;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;
    _childElements = widget.slivers.map((w) {
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
    final newScrollView = newWidget as CustomScrollView;
    final multiNode = renderNode as MultiChildNativeRenderNode;
    final newChildrenWidgets = newScrollView.slivers;

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
