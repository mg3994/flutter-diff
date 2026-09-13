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
