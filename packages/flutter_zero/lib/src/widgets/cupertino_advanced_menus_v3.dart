import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class CupertinoListTileNotched extends NativeRenderWidget {
  final Widget title;
  final Widget? subtitle;
  final void Function()? onTap;

  const CupertinoListTileNotched({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Element createElement() => CupertinoListTileNotchedElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'CupertinoListTileNotched');
  }
}

class CupertinoListTileNotchedElement extends NativeRenderElement {
  Element? _titleEl;
  Element? _subtitleEl;

  CupertinoListTileNotchedElement(CupertinoListTileNotched super.widget);

  @override
  CupertinoListTileNotched get widget => super.widget as CupertinoListTileNotched;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    _titleEl = widget.title.createElement()..mount(this);
    if (_titleEl?.renderNode != null) multiNode.addChild(_titleEl!.renderNode!);

    if (widget.subtitle != null) {
      _subtitleEl = widget.subtitle!.createElement()..mount(this);
      if (_subtitleEl?.renderNode != null) multiNode.addChild(_subtitleEl!.renderNode!);
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
      backend.registerEventListener(handle, 'tap', (name, data) {
        widget.onTap?.call();
      });
    }
  }

  @override
  void unmount() {
    _titleEl?.unmount();
    _subtitleEl?.unmount();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_titleEl != null) visitor(_titleEl!);
    if (_subtitleEl != null) visitor(_subtitleEl!);
  }
}
