import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class CupertinoSlider extends NativeRenderWidget {
  final double value;
  final void Function(double value)? onChanged;
  final double min;
  final double max;

  const CupertinoSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
  });

  @override
  Element createElement() => CupertinoSliderElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return CupertinoSliderRenderNode(
      props: {
        'value': value,
        'min': min,
        'max': max,
      },
    );
  }
}

class CupertinoSliderRenderNode extends NativeRenderNode {
  CupertinoSliderRenderNode({required super.props})
      : super(widgetType: 'CupertinoSlider');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(Size(
      constraints.maxWidth.isFinite ? constraints.maxWidth : 200.0,
      30.0,
    ));
  }
}

class CupertinoSliderElement extends NativeRenderElement {
  CupertinoSliderElement(CupertinoSlider super.widget);

  @override
  CupertinoSlider get widget => super.widget as CupertinoSlider;

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
        final val = (data['value'] as num?)?.toDouble() ?? widget.value;
        widget.onChanged?.call(val);
      });
    }
  }
}
