import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class MenuItemButton extends NativeRenderWidget {
  final Widget child;
  final void Function()? onPressed;

  const MenuItemButton({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Element createElement() => MenuItemButtonElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'MenuItemButton',
      props: {'enabled': onPressed != null},
    );
  }
}

class MenuItemButtonElement extends NativeRenderElement {
  Element? _childEl;

  MenuItemButtonElement(MenuItemButton super.widget);

  @override
  MenuItemButton get widget => super.widget as MenuItemButton;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _childEl = widget.child.createElement()..mount(this);
    if (_childEl?.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _childEl!.renderNode;
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
    if (_childEl != null) visitor(_childEl!);
  }
}

class SubmenuButton extends NativeRenderWidget {
  final Widget child;
  final List<Widget> menuChildren;

  const SubmenuButton({
    super.key,
    required this.child,
    required this.menuChildren,
  });

  @override
  Element createElement() => SubmenuButtonElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'SubmenuButton');
  }
}

class SubmenuButtonElement extends NativeRenderElement {
  Element? _childEl;
  List<Element> _menuChildEls = [];

  SubmenuButtonElement(SubmenuButton super.widget);

  @override
  SubmenuButton get widget => super.widget as SubmenuButton;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    _childEl = widget.child.createElement()..mount(this);
    if (_childEl?.renderNode != null) multiNode.addChild(_childEl!.renderNode!);

    _menuChildEls = widget.menuChildren.map((w) {
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
      return el;
    }).toList();
  }

  @override
  void unmount() {
    _childEl?.unmount();
    for (final el in _menuChildEls) {
      el.unmount();
    }
    _menuChildEls.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childEl != null) visitor(_childEl!);
    for (final el in _menuChildEls) {
      visitor(el);
    }
  }
}

class MenuAnchor extends NativeRenderWidget {
  final List<Widget> menuChildren;
  final Widget? child;

  const MenuAnchor({
    super.key,
    required this.menuChildren,
    this.child,
  });

  @override
  Element createElement() => MenuAnchorElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'MenuAnchor');
  }
}

class MenuAnchorElement extends NativeRenderElement {
  Element? _childEl;
  List<Element> _menuChildEls = [];

  MenuAnchorElement(MenuAnchor super.widget);

  @override
  MenuAnchor get widget => super.widget as MenuAnchor;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    if (widget.child != null) {
      _childEl = widget.child!.createElement()..mount(this);
      if (_childEl?.renderNode != null) multiNode.addChild(_childEl!.renderNode!);
    }

    _menuChildEls = widget.menuChildren.map((w) {
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
      return el;
    }).toList();
  }

  @override
  void unmount() {
    _childEl?.unmount();
    for (final el in _menuChildEls) {
      el.unmount();
    }
    _menuChildEls.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childEl != null) visitor(_childEl!);
    for (final el in _menuChildEls) {
      visitor(el);
    }
  }
}
