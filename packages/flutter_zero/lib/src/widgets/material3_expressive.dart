import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class NavigationDestination {
  final Widget icon;
  final String label;

  const NavigationDestination({
    required this.icon,
    required this.label,
  });
}

class NavigationDrawer extends NativeRenderWidget {
  final List<Widget> children;
  final int selectedIndex;
  final void Function(int index)? onDestinationSelected;

  const NavigationDrawer({
    super.key,
    this.children = const [],
    this.selectedIndex = 0,
    this.onDestinationSelected,
  });

  @override
  Element createElement() => NavigationDrawerElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'NavigationDrawer',
      props: {'selectedIndex': selectedIndex},
    );
  }
}

class NavigationDrawerElement extends NativeRenderElement {
  List<Element> _childElements = [];

  NavigationDrawerElement(NavigationDrawer super.widget);

  @override
  NavigationDrawer get widget => super.widget as NavigationDrawer;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;
    _childElements = widget.children.map((w) {
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
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
    if (backend != null && widget.onDestinationSelected != null) {
      backend.registerEventListener(handle, 'select', (name, data) {
        final index = (data['index'] as num?)?.toInt() ?? 0;
        widget.onDestinationSelected?.call(index);
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

class CarouselView extends NativeRenderWidget {
  final double itemExtent;
  final List<Widget> children;
  final void Function(int index)? onTap;

  const CarouselView({
    super.key,
    required this.itemExtent,
    required this.children,
    this.onTap,
  });

  @override
  Element createElement() => CarouselViewElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'CarouselView',
      props: {'itemExtent': itemExtent},
    );
  }
}

class CarouselViewElement extends NativeRenderElement {
  List<Element> _childElements = [];

  CarouselViewElement(CarouselView super.widget);

  @override
  CarouselView get widget => super.widget as CarouselView;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;
    _childElements = widget.children.map((w) {
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
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
    if (backend != null && widget.onTap != null) {
      backend.registerEventListener(handle, 'tap', (name, data) {
        final index = (data['index'] as num?)?.toInt() ?? 0;
        widget.onTap?.call(index);
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

class AssistChip extends NativeRenderWidget {
  final Widget label;
  final Widget? leading;
  final void Function()? onPressed;

  const AssistChip({
    super.key,
    required this.label,
    this.leading,
    this.onPressed,
  });

  @override
  Element createElement() => AssistChipElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'AssistChip',
      props: {'enabled': onPressed != null},
    );
  }
}

class AssistChipElement extends NativeRenderElement {
  Element? _leadingEl;
  Element? _labelEl;

  AssistChipElement(AssistChip super.widget);

  @override
  AssistChip get widget => super.widget as AssistChip;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    if (widget.leading != null) {
      _leadingEl = widget.leading!.createElement()..mount(this);
      if (_leadingEl?.renderNode != null) multiNode.addChild(_leadingEl!.renderNode!);
    }

    _labelEl = widget.label.createElement()..mount(this);
    if (_labelEl?.renderNode != null) multiNode.addChild(_labelEl!.renderNode!);

    renderNode?.onNativeHandleCreated = (handle) {
      _registerEvents(handle);
    };
    if (renderNode?.nativeHandle != null) {
      _registerEvents(renderNode!.nativeHandle!);
    }
  }

  void _registerEvents(int handle) {
    final backend = appOwner?.backend;
    if (backend != null && widget.onPressed != null) {
      backend.registerEventListener(handle, 'click', (name, data) {
        widget.onPressed?.call();
      });
    }
  }

  @override
  void unmount() {
    _leadingEl?.unmount();
    _labelEl?.unmount();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_leadingEl != null) visitor(_leadingEl!);
    if (_labelEl != null) visitor(_labelEl!);
  }
}

class SuggestionChip extends NativeRenderWidget {
  final Widget label;
  final void Function()? onPressed;

  const SuggestionChip({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Element createElement() => SuggestionChipElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'SuggestionChip',
      props: {'enabled': onPressed != null},
    );
  }
}

class SuggestionChipElement extends NativeRenderElement {
  Element? _labelEl;

  SuggestionChipElement(SuggestionChip super.widget);

  @override
  SuggestionChip get widget => super.widget as SuggestionChip;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _labelEl = widget.label.createElement()..mount(this);
    if (_labelEl!.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _labelEl!.renderNode;
    }

    renderNode?.onNativeHandleCreated = (handle) {
      _registerEvents(handle);
    };
    if (renderNode?.nativeHandle != null) {
      _registerEvents(renderNode!.nativeHandle!);
    }
  }

  void _registerEvents(int handle) {
    final backend = appOwner?.backend;
    if (backend != null && widget.onPressed != null) {
      backend.registerEventListener(handle, 'click', (name, data) {
        widget.onPressed?.call();
      });
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_labelEl != null) visitor(_labelEl!);
  }
}
