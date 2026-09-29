import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class BottomSheet extends NativeRenderWidget {
  final Widget child;
  final String? backgroundColor;
  final double elevation;

  const BottomSheet({
    super.key,
    required this.child,
    this.backgroundColor,
    this.elevation = 0.0,
  });

  @override
  Element createElement() => BottomSheetElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'BottomSheet',
      props: {
        'elevation': elevation,
        if (backgroundColor != null) 'backgroundColor': backgroundColor,
      },
    );
  }
}

class BottomSheetElement extends NativeRenderElement {
  Element? _childElement;

  BottomSheetElement(BottomSheet super.widget);

  @override
  BottomSheet get widget => super.widget as BottomSheet;

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

class MaterialBanner extends NativeRenderWidget {
  final Widget content;
  final List<Widget> actions;
  final Widget? leading;

  const MaterialBanner({
    super.key,
    required this.content,
    required this.actions,
    this.leading,
  });

  @override
  Element createElement() => MaterialBannerElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'MaterialBanner');
  }
}

class MaterialBannerElement extends NativeRenderElement {
  Element? _leadingEl;
  Element? _contentEl;
  List<Element> _actionEls = [];

  MaterialBannerElement(MaterialBanner super.widget);

  @override
  MaterialBanner get widget => super.widget as MaterialBanner;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    if (widget.leading != null) {
      _leadingEl = widget.leading!.createElement()..mount(this);
      if (_leadingEl?.renderNode != null) multiNode.addChild(_leadingEl!.renderNode!);
    }

    _contentEl = widget.content.createElement()..mount(this);
    if (_contentEl?.renderNode != null) multiNode.addChild(_contentEl!.renderNode!);

    _actionEls = widget.actions.map((w) {
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
      return el;
    }).toList();
  }

  @override
  void unmount() {
    _leadingEl?.unmount();
    _contentEl?.unmount();
    for (final el in _actionEls) {
      el.unmount();
    }
    _actionEls.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_leadingEl != null) visitor(_leadingEl!);
    if (_contentEl != null) visitor(_contentEl!);
    for (final el in _actionEls) {
      visitor(el);
    }
  }
}
