import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class AdaptiveCircularProgressIndicator extends NativeRenderWidget {
  final double? value;
  final String? color;

  const AdaptiveCircularProgressIndicator({
    super.key,
    this.value,
    this.color,
  });

  @override
  NativeRenderNode createRenderNode() {
    return AdaptiveCircularProgressRenderNode(
      props: {
        if (value != null) 'value': value,
        if (color != null) 'color': color,
      },
    );
  }
}

class AdaptiveCircularProgressRenderNode extends NativeRenderNode {
  AdaptiveCircularProgressRenderNode({required super.props})
      : super(widgetType: 'AdaptiveCircularProgressIndicator');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(const Size(36.0, 36.0));
  }
}

class AdaptiveSlider extends NativeRenderWidget {
  final double value;
  final void Function(double value)? onChanged;
  final double min;
  final double max;

  const AdaptiveSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
  });

  @override
  Element createElement() => AdaptiveSliderElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return AdaptiveSliderRenderNode(
      props: {
        'value': value,
        'min': min,
        'max': max,
      },
    );
  }
}

class AdaptiveSliderRenderNode extends NativeRenderNode {
  AdaptiveSliderRenderNode({required super.props})
      : super(widgetType: 'AdaptiveSlider');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(Size(
      constraints.maxWidth.isFinite ? constraints.maxWidth : 200.0,
      40.0,
    ));
  }
}

class AdaptiveSliderElement extends NativeRenderElement {
  AdaptiveSliderElement(AdaptiveSlider super.widget);

  @override
  AdaptiveSlider get widget => super.widget as AdaptiveSlider;

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
