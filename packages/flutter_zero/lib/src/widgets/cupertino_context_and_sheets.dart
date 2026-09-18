import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class CupertinoContextMenuAction extends NativeRenderWidget {
  final Widget child;
  final void Function()? onPressed;

  const CupertinoContextMenuAction({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Element createElement() => CupertinoContextMenuActionElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(widgetType: 'CupertinoContextMenuAction');
  }
}

class CupertinoContextMenuActionElement extends NativeRenderElement {
  Element? _childEl;

  CupertinoContextMenuActionElement(CupertinoContextMenuAction super.widget);

  @override
  CupertinoContextMenuAction get widget => super.widget as CupertinoContextMenuAction;

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

class CupertinoContextMenu extends NativeRenderWidget {
  final Widget child;
  final List<Widget> actions;

  const CupertinoContextMenu({
    super.key,
    required this.child,
    required this.actions,
  });

  @override
  Element createElement() => CupertinoContextMenuElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'CupertinoContextMenu');
  }
}

class CupertinoContextMenuElement extends NativeRenderElement {
  Element? _childEl;
  List<Element> _actionEls = [];

  CupertinoContextMenuElement(CupertinoContextMenu super.widget);

  @override
  CupertinoContextMenu get widget => super.widget as CupertinoContextMenu;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    _childEl = widget.child.createElement()..mount(this);
    if (_childEl?.renderNode != null) multiNode.addChild(_childEl!.renderNode!);

    _actionEls = widget.actions.map((w) {
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
      return el;
    }).toList();
  }

  @override
  void unmount() {
    _childEl?.unmount();
    for (final el in _actionEls) {
      el.unmount();
    }
    _actionEls.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childEl != null) visitor(_childEl!);
    for (final el in _actionEls) {
      visitor(el);
    }
  }
}
