import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class PageController {
  final int initialPage;
  int _currentPage;

  PageController({this.initialPage = 0}) : _currentPage = initialPage;

  int get page => _currentPage;

  void jumpToPage(int page) {
    _currentPage = page;
  }
}

class PageView extends NativeRenderWidget {
  final List<Widget> children;
  final PageController? controller;
  final void Function(int page)? onPageChanged;

  const PageView({
    super.key,
    this.children = const [],
    this.controller,
    this.onPageChanged,
  });

  @override
  Element createElement() => PageViewElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'PageView',
      props: {'initialPage': controller?.initialPage ?? 0},
    );
  }
}

class PageViewElement extends NativeRenderElement {
  List<Element> _childElements = [];

  PageViewElement(PageView super.widget);

  @override
  PageView get widget => super.widget as PageView;

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

    renderNode?.onNativeHandleCreated = (handle) {
      _registerEvents(handle);
    };
    if (renderNode?.nativeHandle != null) {
      _registerEvents(renderNode!.nativeHandle!);
    }
  }

  void _registerEvents(int handle) {
    final backend = appOwner?.backend;
    if (backend != null) {
      backend.registerEventListener(handle, 'pageChange', (eventName, data) {
        final newPage = (data['page'] as num?)?.toInt() ?? 0;
        widget.controller?.jumpToPage(newPage);
        widget.onPageChanged?.call(newPage);
      });
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

class SliverToBoxAdapter extends NativeRenderWidget {
  final Widget child;

  const SliverToBoxAdapter({
    super.key,
    required this.child,
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
    _childElement = widget.child.createElement();
    _childElement!.mount(this);
    if (_childElement!.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _childElement!.renderNode;
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}

class SliverPadding extends NativeRenderWidget {
  final double padding;
  final Widget sliver;

  const SliverPadding({
    super.key,
    required this.padding,
    required this.sliver,
  });

  @override
  Element createElement() => SliverPaddingElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'SliverPadding',
      props: {'padding': padding},
    );
  }
}

class SliverPaddingElement extends NativeRenderElement {
  Element? _sliverElement;

  SliverPaddingElement(SliverPadding super.widget);

  @override
  SliverPadding get widget => super.widget as SliverPadding;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _sliverElement = widget.sliver.createElement();
    _sliverElement!.mount(this);
    if (_sliverElement!.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _sliverElement!.renderNode;
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_sliverElement != null) visitor(_sliverElement!);
  }
}
