import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

// --- Navigation & Material Structure Widgets ---

class Drawer extends NativeRenderWidget {
  final Widget? child;
  final double elevation;

  const Drawer({
    super.key,
    this.child,
    this.elevation = 16.0,
  });

  @override
  Element createElement() => DrawerElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'Drawer',
      props: {'elevation': elevation},
    );
  }
}

class DrawerElement extends NativeRenderElement {
  Element? _childElement;

  DrawerElement(Drawer super.widget);

  @override
  Drawer get widget => super.widget as Drawer;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final childWidget = widget.child;
    if (childWidget != null) {
      _childElement = childWidget.createElement();
      _childElement!.mount(this);
      if (_childElement!.renderNode != null) {
        (renderNode as SingleChildNativeRenderNode).child = _childElement!.renderNode;
      }
    }
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    final newDrawer = newWidget as Drawer;
    final newChildWidget = newDrawer.child;
    final currentChild = _childElement;

    if (currentChild == null && newChildWidget != null) {
      _childElement = newChildWidget.createElement();
      _childElement!.mount(this);
    } else if (currentChild != null && newChildWidget == null) {
      currentChild.unmount();
      _childElement = null;
    } else if (currentChild != null && newChildWidget != null) {
      if (Widget.canUpdate(currentChild.widget, newChildWidget)) {
        currentChild.update(newChildWidget);
      } else {
        currentChild.unmount();
        _childElement = newChildWidget.createElement();
        _childElement!.mount(this);
      }
    }

    (renderNode as SingleChildNativeRenderNode).child = _childElement?.renderNode;
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

class BottomNavigationBarItem {
  final Widget icon;
  final String label;

  const BottomNavigationBarItem({
    required this.icon,
    required this.label,
  });
}

class BottomNavigationBar extends NativeRenderWidget {
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final void Function(int index)? onTap;

  const BottomNavigationBar({
    super.key,
    required this.items,
    this.currentIndex = 0,
    this.onTap,
  });

  @override
  Element createElement() => BottomNavigationBarElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'BottomNavigationBar',
      props: {
        'currentIndex': currentIndex,
        'itemLabels': items.map((e) => e.label).toList(),
      },
    );
  }
}

class BottomNavigationBarElement extends NativeRenderElement {
  List<Element> _iconElements = [];

  BottomNavigationBarElement(BottomNavigationBar super.widget);

  @override
  BottomNavigationBar get widget => super.widget as BottomNavigationBar;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;
    _iconElements = widget.items.map((item) {
      final el = item.icon.createElement();
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
    if (backend != null && widget.onTap != null) {
      backend.registerEventListener(handle, 'tap', (eventName, data) {
        final index = (data['index'] as num?)?.toInt() ?? 0;
        widget.onTap?.call(index);
      });
    }
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    if (renderNode?.nativeHandle != null) {
      _registerEvents(renderNode!.nativeHandle!);
    }
  }

  @override
  void unmount() {
    for (final el in _iconElements) {
      el.unmount();
    }
    _iconElements.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    for (final el in _iconElements) {
      visitor(el);
    }
  }
}

class ListTile extends NativeRenderWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final void Function()? onTap;

  const ListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Element createElement() => ListTileElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'ListTile');
  }
}

class ListTileElement extends NativeRenderElement {
  Element? _leadingEl;
  Element? _titleEl;
  Element? _subtitleEl;
  Element? _trailingEl;

  ListTileElement(ListTile super.widget);

  @override
  ListTile get widget => super.widget as ListTile;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    if (widget.leading != null) {
      _leadingEl = widget.leading!.createElement()..mount(this);
      if (_leadingEl?.renderNode != null) multiNode.addChild(_leadingEl!.renderNode!);
    }
    if (widget.title != null) {
      _titleEl = widget.title!.createElement()..mount(this);
      if (_titleEl?.renderNode != null) multiNode.addChild(_titleEl!.renderNode!);
    }
    if (widget.subtitle != null) {
      _subtitleEl = widget.subtitle!.createElement()..mount(this);
      if (_subtitleEl?.renderNode != null) multiNode.addChild(_subtitleEl!.renderNode!);
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
    if (backend != null && widget.onTap != null) {
      backend.registerEventListener(handle, 'tap', (eventName, data) {
        widget.onTap?.call();
      });
    }
  }

  @override
  void unmount() {
    _leadingEl?.unmount();
    _titleEl?.unmount();
    _subtitleEl?.unmount();
    _trailingEl?.unmount();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_leadingEl != null) visitor(_leadingEl!);
    if (_titleEl != null) visitor(_titleEl!);
    if (_subtitleEl != null) visitor(_subtitleEl!);
    if (_trailingEl != null) visitor(_trailingEl!);
  }
}

class Card extends NativeRenderWidget {
  final Widget? child;
  final double elevation;
  final String? color;

  const Card({
    super.key,
    this.child,
    this.elevation = 1.0,
    this.color,
  });

  @override
  Element createElement() => CardElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'Card',
      props: {
        'elevation': elevation,
        if (color != null) 'color': color,
      },
    );
  }
}

class CardElement extends NativeRenderElement {
  Element? _childElement;

  CardElement(Card super.widget);

  @override
  Card get widget => super.widget as Card;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final childWidget = widget.child;
    if (childWidget != null) {
      _childElement = childWidget.createElement();
      _childElement!.mount(this);
      if (_childElement!.renderNode != null) {
        (renderNode as SingleChildNativeRenderNode).child = _childElement!.renderNode;
      }
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}

class Divider extends NativeRenderWidget {
  final double height;
  final double thickness;
  final String? color;

  const Divider({
    super.key,
    this.height = 16.0,
    this.thickness = 1.0,
    this.color,
  });

  @override
  NativeRenderNode createRenderNode() {
    return DividerRenderNode(
      props: {
        'height': height,
        'thickness': thickness,
        if (color != null) 'color': color,
      },
    );
  }
}

class DividerRenderNode extends NativeRenderNode {
  DividerRenderNode({required super.props}) : super(widgetType: 'Divider');

  @override
  void performLayout(BoxConstraints constraints) {
    final double h = (props['height'] as num?)?.toDouble() ?? 16.0;
    size = constraints.constrain(Size(
      constraints.maxWidth.isFinite ? constraints.maxWidth : 300.0,
      h,
    ));
  }
}

class Badge extends NativeRenderWidget {
  final Widget? child;
  final String? label;

  const Badge({
    super.key,
    this.child,
    this.label,
  });

  @override
  Element createElement() => BadgeElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'Badge',
      props: {if (label != null) 'label': label},
    );
  }
}

class BadgeElement extends NativeRenderElement {
  Element? _childElement;

  BadgeElement(Badge super.widget);

  @override
  Badge get widget => super.widget as Badge;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final childWidget = widget.child;
    if (childWidget != null) {
      _childElement = childWidget.createElement();
      _childElement!.mount(this);
      if (_childElement!.renderNode != null) {
        (renderNode as SingleChildNativeRenderNode).child = _childElement!.renderNode;
      }
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}

// --- Inputs & Controls ---

class Radio<T> extends NativeRenderWidget {
  final T value;
  final T? groupValue;
  final void Function(T? value)? onChanged;

  const Radio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Element createElement() => RadioElement<T>(this);

  @override
  NativeRenderNode createRenderNode() {
    return RadioRenderNode(
      props: {'selected': value == groupValue},
    );
  }
}

class RadioRenderNode extends NativeRenderNode {
  RadioRenderNode({required super.props}) : super(widgetType: 'Radio');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(const Size(24.0, 24.0));
  }
}

class RadioElement<T> extends NativeRenderElement {
  RadioElement(Radio<T> super.widget);

  @override
  Radio<T> get widget => super.widget as Radio<T>;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    renderNode?.onNativeHandleCreated = (handle) {
      _registerEvents(handle);
    };
    if (renderNode?.nativeHandle != null) {
      _registerEvents(renderNode!.nativeHandle!);
    }
  }

  void _registerEvents(int handle) {
    final backend = appOwner?.backend;
    if (backend != null && widget.onChanged != null) {
      backend.registerEventListener(handle, 'click', (eventName, data) {
        widget.onChanged?.call(widget.value);
      });
    }
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    if (renderNode?.nativeHandle != null) {
      _registerEvents(renderNode!.nativeHandle!);
    }
  }
}

class DropdownMenuItem<T> {
  final T value;
  final Widget child;

  const DropdownMenuItem({
    required this.value,
    required this.child,
  });
}

class DropdownButton<T> extends NativeRenderWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T? value)? onChanged;

  const DropdownButton({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Element createElement() => DropdownButtonElement<T>(this);

  @override
  NativeRenderNode createRenderNode() {
    return DropdownRenderNode(
      props: {
        'selectedValue': value?.toString(),
        'itemCount': items.length,
      },
    );
  }
}

class DropdownRenderNode extends NativeRenderNode {
  DropdownRenderNode({required super.props}) : super(widgetType: 'DropdownButton');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(Size(
      constraints.maxWidth.isFinite ? constraints.maxWidth : 160.0,
      40.0,
    ));
  }
}

class DropdownButtonElement<T> extends NativeRenderElement {
  List<Element> _itemChildElements = [];

  DropdownButtonElement(DropdownButton<T> super.widget);

  @override
  DropdownButton<T> get widget => super.widget as DropdownButton<T>;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _itemChildElements = widget.items.map((item) {
      final el = item.child.createElement();
      el.mount(this);
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
    if (backend != null && widget.onChanged != null) {
      backend.registerEventListener(handle, 'select', (eventName, data) {
        final selectedIndex = (data['index'] as num?)?.toInt() ?? 0;
        if (selectedIndex >= 0 && selectedIndex < widget.items.length) {
          widget.onChanged?.call(widget.items[selectedIndex].value);
        }
      });
    }
  }

  @override
  void unmount() {
    for (final el in _itemChildElements) {
      el.unmount();
    }
    _itemChildElements.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    for (final el in _itemChildElements) {
      visitor(el);
    }
  }
}

// --- Animation & Transition Widgets ---

class AnimatedContainer extends NativeRenderWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final String? backgroundColor;
  final Duration duration;

  const AnimatedContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.backgroundColor,
    required this.duration,
  });

  @override
  Element createElement() => AnimatedContainerElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'AnimatedContainer',
      props: {
        'durationMs': duration.inMilliseconds,
        if (width != null) 'width': width,
        if (height != null) 'height': height,
        if (backgroundColor != null) 'backgroundColor': backgroundColor,
      },
    );
  }
}

class AnimatedContainerElement extends NativeRenderElement {
  Element? _childElement;

  AnimatedContainerElement(AnimatedContainer super.widget);

  @override
  AnimatedContainer get widget => super.widget as AnimatedContainer;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final childWidget = widget.child;
    if (childWidget != null) {
      _childElement = childWidget.createElement();
      _childElement!.mount(this);
      if (_childElement!.renderNode != null) {
        (renderNode as SingleChildNativeRenderNode).child = _childElement!.renderNode;
      }
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}

class AnimatedOpacity extends NativeRenderWidget {
  final Widget child;
  final double opacity;
  final Duration duration;

  const AnimatedOpacity({
    super.key,
    required this.child,
    required this.opacity,
    required this.duration,
  });

  @override
  Element createElement() => AnimatedOpacityElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'AnimatedOpacity',
      props: {
        'opacity': opacity,
        'durationMs': duration.inMilliseconds,
      },
    );
  }
}

class AnimatedOpacityElement extends NativeRenderElement {
  Element? _childElement;

  AnimatedOpacityElement(AnimatedOpacity super.widget);

  @override
  AnimatedOpacity get widget => super.widget as AnimatedOpacity;

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

class FadeTransition extends NativeRenderWidget {
  final Widget child;
  final double opacity;

  const FadeTransition({
    super.key,
    required this.child,
    required this.opacity,
  });

  @override
  Element createElement() => FadeTransitionElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'FadeTransition',
      props: {'opacity': opacity},
    );
  }
}

class FadeTransitionElement extends NativeRenderElement {
  Element? _childElement;

  FadeTransitionElement(FadeTransition super.widget);

  @override
  FadeTransition get widget => super.widget as FadeTransition;

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

class Hero extends NativeRenderWidget {
  final String tag;
  final Widget child;

  const Hero({
    super.key,
    required this.tag,
    required this.child,
  });

  @override
  Element createElement() => HeroElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'Hero',
      props: {'tag': tag},
    );
  }
}

class HeroElement extends NativeRenderElement {
  Element? _childElement;

  HeroElement(Hero super.widget);

  @override
  Hero get widget => super.widget as Hero;

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

// --- Visual Effects & Interaction Features ---

class Opacity extends NativeRenderWidget {
  final double opacity;
  final Widget child;

  const Opacity({
    super.key,
    required this.opacity,
    required this.child,
  });

  @override
  Element createElement() => OpacityElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'Opacity',
      props: {'opacity': opacity},
    );
  }
}

class OpacityElement extends NativeRenderElement {
  Element? _childElement;

  OpacityElement(Opacity super.widget);

  @override
  Opacity get widget => super.widget as Opacity;

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

class Dismissible extends NativeRenderWidget {
  final Widget child;
  final void Function()? onDismissed;

  const Dismissible({
    super.key,
    required this.child,
    this.onDismissed,
  });

  @override
  Element createElement() => DismissibleElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(widgetType: 'Dismissible');
  }
}

class DismissibleElement extends NativeRenderElement {
  Element? _childElement;

  DismissibleElement(Dismissible super.widget);

  @override
  Dismissible get widget => super.widget as Dismissible;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _childElement = widget.child.createElement();
    _childElement!.mount(this);
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
    if (backend != null && widget.onDismissed != null) {
      backend.registerEventListener(handle, 'dismiss', (eventName, data) {
        widget.onDismissed?.call();
      });
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}

class ReorderableListView extends NativeRenderWidget {
  final List<Widget> children;
  final void Function(int oldIndex, int newIndex)? onReorder;

  const ReorderableListView({
    super.key,
    required this.children,
    this.onReorder,
  });

  @override
  Element createElement() => ReorderableListViewElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'ReorderableListView');
  }
}

class ReorderableListViewElement extends NativeRenderElement {
  List<Element> _childElements = [];

  ReorderableListViewElement(ReorderableListView super.widget);

  @override
  ReorderableListView get widget => super.widget as ReorderableListView;

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
    if (backend != null && widget.onReorder != null) {
      backend.registerEventListener(handle, 'reorder', (eventName, data) {
        final oldIndex = (data['oldIndex'] as num?)?.toInt() ?? 0;
        final newIndex = (data['newIndex'] as num?)?.toInt() ?? 0;
        widget.onReorder?.call(oldIndex, newIndex);
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
