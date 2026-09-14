import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class CupertinoButton extends NativeRenderWidget {
  final Widget child;
  final void Function()? onPressed;
  final String? color;

  const CupertinoButton({
    super.key,
    required this.child,
    this.onPressed,
    this.color,
  });

  @override
  Element createElement() => CupertinoButtonElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'CupertinoButton',
      props: {
        'enabled': onPressed != null,
        if (color != null) 'color': color,
      },
    );
  }
}

class CupertinoButtonElement extends NativeRenderElement {
  Element? _childElement;

  CupertinoButtonElement(CupertinoButton super.widget);

  @override
  CupertinoButton get widget => super.widget as CupertinoButton;

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
    if (backend != null && widget.onPressed != null) {
      backend.registerEventListener(handle, 'click', (eventName, data) {
        widget.onPressed?.call();
      });
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}

class CupertinoSwitch extends NativeRenderWidget {
  final bool value;
  final void Function(bool value)? onChanged;

  const CupertinoSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Element createElement() => CupertinoSwitchElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return CupertinoSwitchRenderNode(
      props: {'value': value},
    );
  }
}

class CupertinoSwitchRenderNode extends NativeRenderNode {
  CupertinoSwitchRenderNode({required super.props})
      : super(widgetType: 'CupertinoSwitch');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(const Size(51.0, 31.0));
  }
}

class CupertinoSwitchElement extends NativeRenderElement {
  CupertinoSwitchElement(CupertinoSwitch super.widget);

  @override
  CupertinoSwitch get widget => super.widget as CupertinoSwitch;

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
      backend.registerEventListener(handle, 'change', (eventName, data) {
        final newVal = (data['value'] as bool?) ?? !widget.value;
        widget.onChanged?.call(newVal);
      });
    }
  }
}

class CupertinoActivityIndicator extends NativeRenderWidget {
  final bool animating;
  final double radius;

  const CupertinoActivityIndicator({
    super.key,
    this.animating = true,
    this.radius = 10.0,
  });

  @override
  NativeRenderNode createRenderNode() {
    return CupertinoActivityRenderNode(
      props: {
        'animating': animating,
        'radius': radius,
      },
    );
  }
}

class CupertinoActivityRenderNode extends NativeRenderNode {
  CupertinoActivityRenderNode({required super.props})
      : super(widgetType: 'CupertinoActivityIndicator');

  @override
  void performLayout(BoxConstraints constraints) {
    final double r = (props['radius'] as num?)?.toDouble() ?? 10.0;
    final double diameter = r * 2;
    size = constraints.constrain(Size(diameter, diameter));
  }
}
