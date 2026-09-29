import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import '../navigation/navigator.dart';
import 'widgets.dart';

class CupertinoModalPopupRoute<T> extends PageRoute<T> {
  final Widget Function(BuildContext context) builder;

  CupertinoModalPopupRoute({required this.builder}) : super(builder: builder);
}

class CupertinoSliverNavigationBar extends NativeRenderWidget {
  final Widget? largeTitle;
  final Widget? leading;
  final Widget? trailing;

  const CupertinoSliverNavigationBar({
    super.key,
    this.largeTitle,
    this.leading,
    this.trailing,
  });

  @override
  Element createElement() => CupertinoSliverNavigationBarElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'CupertinoSliverNavigationBar');
  }
}

class CupertinoSliverNavigationBarElement extends NativeRenderElement {
  Element? _titleEl;
  Element? _leadingEl;
  Element? _trailingEl;

  CupertinoSliverNavigationBarElement(CupertinoSliverNavigationBar super.widget);

  @override
  CupertinoSliverNavigationBar get widget => super.widget as CupertinoSliverNavigationBar;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    if (widget.largeTitle != null) {
      _titleEl = widget.largeTitle!.createElement()..mount(this);
      if (_titleEl?.renderNode != null) multiNode.addChild(_titleEl!.renderNode!);
    }

    if (widget.leading != null) {
      _leadingEl = widget.leading!.createElement()..mount(this);
      if (_leadingEl?.renderNode != null) multiNode.addChild(_leadingEl!.renderNode!);
    }

    if (widget.trailing != null) {
      _trailingEl = widget.trailing!.createElement()..mount(this);
      if (_trailingEl?.renderNode != null) multiNode.addChild(_trailingEl!.renderNode!);
    }
  }

  @override
  void unmount() {
    _titleEl?.unmount();
    _leadingEl?.unmount();
    _trailingEl?.unmount();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_titleEl != null) visitor(_titleEl!);
    if (_leadingEl != null) visitor(_leadingEl!);
    if (_trailingEl != null) visitor(_trailingEl!);
  }
}
