import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class CupertinoNavigationBar extends NativeRenderWidget {
  final Widget? leading;
  final Widget? middle;
  final Widget? trailing;

  const CupertinoNavigationBar({
    super.key,
    this.leading,
    this.middle,
    this.trailing,
  });

  @override
  Element createElement() => CupertinoNavigationBarElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'CupertinoNavigationBar');
  }
}

class CupertinoNavigationBarElement extends NativeRenderElement {
  Element? _leadingEl;
  Element? _middleEl;
  Element? _trailingEl;

  CupertinoNavigationBarElement(CupertinoNavigationBar super.widget);

  @override
  CupertinoNavigationBar get widget => super.widget as CupertinoNavigationBar;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    if (widget.leading != null) {
      _leadingEl = widget.leading!.createElement()..mount(this);
      if (_leadingEl?.renderNode != null) multiNode.addChild(_leadingEl!.renderNode!);
    }
    if (widget.middle != null) {
      _middleEl = widget.middle!.createElement()..mount(this);
      if (_middleEl?.renderNode != null) multiNode.addChild(_middleEl!.renderNode!);
    }
    if (widget.trailing != null) {
      _trailingEl = widget.trailing!.createElement()..mount(this);
      if (_trailingEl?.renderNode != null) multiNode.addChild(_trailingEl!.renderNode!);
    }
  }

  @override
  void unmount() {
    _leadingEl?.unmount();
    _middleEl?.unmount();
    _trailingEl?.unmount();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_leadingEl != null) visitor(_leadingEl!);
    if (_middleEl != null) visitor(_middleEl!);
    if (_trailingEl != null) visitor(_trailingEl!);
  }
}

class CupertinoTextField extends NativeRenderWidget {
  final String? placeholder;
  final void Function(String text)? onChanged;

  const CupertinoTextField({
    super.key,
    this.placeholder,
    this.onChanged,
  });

  @override
  Element createElement() => CupertinoTextFieldElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return CupertinoTextFieldRenderNode(
      props: {if (placeholder != null) 'placeholder': placeholder},
    );
  }
}

class CupertinoTextFieldRenderNode extends NativeRenderNode {
  CupertinoTextFieldRenderNode({required super.props})
      : super(widgetType: 'CupertinoTextField');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(Size(
      constraints.maxWidth.isFinite ? constraints.maxWidth : 200.0,
      36.0,
    ));
  }
}

class CupertinoTextFieldElement extends NativeRenderElement {
  CupertinoTextFieldElement(CupertinoTextField super.widget);

  @override
  CupertinoTextField get widget => super.widget as CupertinoTextField;

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
      backend.registerEventListener(handle, 'change', (name, data) {
        final txt = (data['text'] as String?) ?? '';
        widget.onChanged?.call(txt);
      });
    }
  }
}
