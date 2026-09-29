import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class SwitchFormField extends NativeRenderWidget {
  final bool value;
  final void Function(bool value)? onChanged;
  final String? Function(bool value)? validator;

  const SwitchFormField({
    super.key,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  @override
  Element createElement() => SwitchFormFieldElement(this);

  @override
  NativeRenderNode createRenderNode() {
    final String? errorText = validator?.call(value);
    return SwitchFormFieldRenderNode(
      props: {
        'value': value,
        if (errorText != null) 'errorText': errorText,
      },
    );
  }
}

class SwitchFormFieldRenderNode extends NativeRenderNode {
  SwitchFormFieldRenderNode({required super.props})
      : super(widgetType: 'SwitchFormField');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(const Size(51.0, 31.0));
  }
}

class SwitchFormFieldElement extends NativeRenderElement {
  SwitchFormFieldElement(SwitchFormField super.widget);

  @override
  SwitchFormField get widget => super.widget as SwitchFormField;

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
        final newVal = (data['value'] as bool?) ?? !widget.value;
        widget.onChanged?.call(newVal);
      });
    }
  }
}
