import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class NavigationBar extends NativeRenderWidget {
  final List<Widget> destinations;
  final int selectedIndex;
  final void Function(int index)? onDestinationSelected;

  const NavigationBar({
    super.key,
    required this.destinations,
    this.selectedIndex = 0,
    this.onDestinationSelected,
  });

  @override
  Element createElement() => NavigationBarElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'NavigationBar',
      props: {'selectedIndex': selectedIndex},
    );
  }
}

class NavigationBarElement extends NativeRenderElement {
  List<Element> _destinationElements = [];

  NavigationBarElement(NavigationBar super.widget);

  @override
  NavigationBar get widget => super.widget as NavigationBar;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    _destinationElements = widget.destinations.map((w) {
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
    for (final el in _destinationElements) {
      el.unmount();
    }
    _destinationElements.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    for (final el in _destinationElements) {
      visitor(el);
    }
  }
}

class NavigationRailDestination {
  final Widget icon;
  final Widget label;

  const NavigationRailDestination({
    required this.icon,
    required this.label,
  });
}

class NavigationRail extends NativeRenderWidget {
  final List<NavigationRailDestination> destinations;
  final int selectedIndex;
  final void Function(int index)? onDestinationSelected;
  final Widget? leading;
  final Widget? trailing;

  const NavigationRail({
    super.key,
    required this.destinations,
    this.selectedIndex = 0,
    this.onDestinationSelected,
    this.leading,
    this.trailing,
  });

  @override
  Element createElement() => NavigationRailElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'NavigationRail',
      props: {'selectedIndex': selectedIndex},
    );
  }
}

class NavigationRailElement extends NativeRenderElement {
  Element? _leadingEl;
  Element? _trailingEl;
  List<Element> _destinationElements = [];

  NavigationRailElement(NavigationRail super.widget);

  @override
  NavigationRail get widget => super.widget as NavigationRail;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    if (widget.leading != null) {
      _leadingEl = widget.leading!.createElement()..mount(this);
      if (_leadingEl?.renderNode != null) multiNode.addChild(_leadingEl!.renderNode!);
    }

    for (final dest in widget.destinations) {
      final iconEl = dest.icon.createElement()..mount(this);
      if (iconEl.renderNode != null) multiNode.addChild(iconEl.renderNode!);
      _destinationElements.add(iconEl);

      final labelEl = dest.label.createElement()..mount(this);
      if (labelEl.renderNode != null) multiNode.addChild(labelEl.renderNode!);
      _destinationElements.add(labelEl);
    }

    if (widget.trailing != null) {
      _trailingEl = widget.trailing!.createElement()..mount(this);
      if (_trailingEl?.renderNode != null) multiNode.addChild(_trailingEl!.renderNode!);
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
    if (backend != null && widget.onDestinationSelected != null) {
      backend.registerEventListener(handle, 'select', (name, data) {
        final index = (data['index'] as num?)?.toInt() ?? 0;
        widget.onDestinationSelected?.call(index);
      });
    }
  }

  @override
  void unmount() {
    _leadingEl?.unmount();
    _trailingEl?.unmount();
    for (final el in _destinationElements) {
      el.unmount();
    }
    _destinationElements.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_leadingEl != null) visitor(_leadingEl!);
    for (final el in _destinationElements) {
      visitor(el);
    }
    if (_trailingEl != null) visitor(_trailingEl!);
  }
}

class FloatingActionButton extends NativeRenderWidget {
  final Widget child;
  final void Function()? onPressed;
  final String? backgroundColor;

  const FloatingActionButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
  });

  @override
  Element createElement() => FloatingActionButtonElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'FloatingActionButton',
      props: {
        'enabled': onPressed != null,
        if (backgroundColor != null) 'backgroundColor': backgroundColor,
      },
    );
  }
}

class FloatingActionButtonElement extends NativeRenderElement {
  Element? _childElement;

  FloatingActionButtonElement(FloatingActionButton super.widget);

  @override
  FloatingActionButton get widget => super.widget as FloatingActionButton;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _childElement = widget.child.createElement()..mount(this);
    if (_childElement!.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _childElement!.renderNode;
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
    if (_childElement != null) visitor(_childElement!);
  }
}
