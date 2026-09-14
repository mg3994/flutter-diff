import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class CheckboxFormField extends NativeRenderWidget {
  final bool value;
  final void Function(bool? value)? onChanged;
  final String? Function(bool? value)? validator;

  const CheckboxFormField({
    super.key,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  @override
  Element createElement() => CheckboxFormFieldElement(this);

  @override
  NativeRenderNode createRenderNode() {
    final String? errorText = validator?.call(value);
    return CheckboxFormFieldRenderNode(
      props: {
        'value': value,
        if (errorText != null) 'errorText': errorText,
      },
    );
  }
}

class CheckboxFormFieldRenderNode extends NativeRenderNode {
  CheckboxFormFieldRenderNode({required super.props})
      : super(widgetType: 'CheckboxFormField');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(const Size(24.0, 24.0));
  }
}

class CheckboxFormFieldElement extends NativeRenderElement {
  CheckboxFormFieldElement(CheckboxFormField super.widget);

  @override
  CheckboxFormField get widget => super.widget as CheckboxFormField;

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
