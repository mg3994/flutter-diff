import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class RadioFormField<T> extends NativeRenderWidget {
  final T value;
  final T? groupValue;
  final void Function(T? value)? onChanged;
  final String? Function(T? value)? validator;

  const RadioFormField({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.validator,
  });

  @override
  Element createElement() => RadioFormFieldElement<T>(this);

  @override
  NativeRenderNode createRenderNode() {
    final String? errorText = validator?.call(groupValue);
    return RadioFormFieldRenderNode(
      props: {
        'selected': value == groupValue,
        if (errorText != null) 'errorText': errorText,
      },
    );
  }
}

class RadioFormFieldRenderNode extends NativeRenderNode {
  RadioFormFieldRenderNode({required super.props})
      : super(widgetType: 'RadioFormField');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(const Size(24.0, 24.0));
  }
}

class RadioFormFieldElement<T> extends NativeRenderElement {
  RadioFormFieldElement(RadioFormField<T> super.widget);

  @override
  RadioFormField<T> get widget => super.widget as RadioFormField<T>;

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
      backend.registerEventListener(handle, 'click', (name, data) {
        widget.onChanged?.call(widget.value);
      });
    }
  }
}
