import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

abstract class ScrollPhysics {
  const ScrollPhysics();
}

class BouncingScrollPhysics extends ScrollPhysics {
  const BouncingScrollPhysics();
}

class ClampingScrollPhysics extends ScrollPhysics {
  const ClampingScrollPhysics();
}

class Listener extends NativeRenderWidget {
  final Widget child;
  final void Function(Map<String, dynamic> event)? onPointerDown;
  final void Function(Map<String, dynamic> event)? onPointerMove;
  final void Function(Map<String, dynamic> event)? onPointerUp;

  const Listener({
    super.key,
    required this.child,
    this.onPointerDown,
    this.onPointerMove,
    this.onPointerUp,
  });

  @override
  Element createElement() => ListenerElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(widgetType: 'Listener');
  }
}

class ListenerElement extends NativeRenderElement {
  Element? _childElement;

  ListenerElement(Listener super.widget);

  @override
  Listener get widget => super.widget as Listener;

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
    if (backend != null) {
      if (widget.onPointerDown != null) {
        backend.registerEventListener(handle, 'pointerDown', (name, data) => widget.onPointerDown?.call(data));
      }
      if (widget.onPointerMove != null) {
        backend.registerEventListener(handle, 'pointerMove', (name, data) => widget.onPointerMove?.call(data));
      }
      if (widget.onPointerUp != null) {
        backend.registerEventListener(handle, 'pointerUp', (name, data) => widget.onPointerUp?.call(data));
      }
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}

class MouseRegion extends NativeRenderWidget {
  final Widget child;
  final void Function(Map<String, dynamic> event)? onEnter;
  final void Function(Map<String, dynamic> event)? onExit;
  final void Function(Map<String, dynamic> event)? onHover;

  const MouseRegion({
    super.key,
    required this.child,
    this.onEnter,
    this.onExit,
    this.onHover,
  });

  @override
  Element createElement() => MouseRegionElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(widgetType: 'MouseRegion');
  }
}

class MouseRegionElement extends NativeRenderElement {
  Element? _childElement;

  MouseRegionElement(MouseRegion super.widget);

  @override
  MouseRegion get widget => super.widget as MouseRegion;

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
    if (backend != null) {
      if (widget.onEnter != null) {
        backend.registerEventListener(handle, 'mouseEnter', (name, data) => widget.onEnter?.call(data));
      }
      if (widget.onExit != null) {
        backend.registerEventListener(handle, 'mouseExit', (name, data) => widget.onExit?.call(data));
      }
      if (widget.onHover != null) {
        backend.registerEventListener(handle, 'mouseHover', (name, data) => widget.onHover?.call(data));
      }
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}
