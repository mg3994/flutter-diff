import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class CupertinoListTile extends NativeRenderWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final void Function()? onTap;

  const CupertinoListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  @override
  Element createElement() => CupertinoListTileElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'CupertinoListTile');
  }
}

class CupertinoListTileElement extends NativeRenderElement {
  Element? _leadingEl;
  Element? _titleEl;
  Element? _subtitleEl;
  Element? _trailingEl;

  CupertinoListTileElement(CupertinoListTile super.widget);

  @override
  CupertinoListTile get widget => super.widget as CupertinoListTile;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    if (widget.leading != null) {
      _leadingEl = widget.leading!.createElement()..mount(this);
      if (_leadingEl?.renderNode != null) multiNode.addChild(_leadingEl!.renderNode!);
    }

    _titleEl = widget.title.createElement()..mount(this);
    if (_titleEl?.renderNode != null) multiNode.addChild(_titleEl!.renderNode!);

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
      backend.registerEventListener(handle, 'tap', (name, data) {
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

class CupertinoListSection extends NativeRenderWidget {
  final List<Widget> children;
  final Widget? header;

  const CupertinoListSection({
    super.key,
    required this.children,
    this.header,
  });

  @override
  Element createElement() => CupertinoListSectionElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'CupertinoListSection');
  }
}

class CupertinoListSectionElement extends NativeRenderElement {
  Element? _headerEl;
  List<Element> _childEls = [];

  CupertinoListSectionElement(CupertinoListSection super.widget);

  @override
  CupertinoListSection get widget => super.widget as CupertinoListSection;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    if (widget.header != null) {
      _headerEl = widget.header!.createElement()..mount(this);
      if (_headerEl?.renderNode != null) multiNode.addChild(_headerEl!.renderNode!);
    }

    _childEls = widget.children.map((w) {
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
      return el;
    }).toList();
  }

  @override
  void unmount() {
    _headerEl?.unmount();
    for (final el in _childEls) {
      el.unmount();
    }
    _childEls.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_headerEl != null) visitor(_headerEl!);
    for (final el in _childEls) {
      visitor(el);
    }
  }
}
