import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class DropdownButtonFormField<T> extends NativeRenderWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T? value)? onChanged;
  final String? Function(T? value)? validator;

  const DropdownButtonFormField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Element createElement() => DropdownButtonFormFieldElement<T>(this);

  @override
  NativeRenderNode createRenderNode() {
    final String? errorText = validator?.call(value);
    return DropdownButtonFormFieldRenderNode(
      props: {
        'selectedValue': value?.toString(),
        'itemCount': items.length,
        if (errorText != null) 'errorText': errorText,
      },
    );
  }
}

class DropdownButtonFormFieldRenderNode extends NativeRenderNode {
  DropdownButtonFormFieldRenderNode({required super.props})
      : super(widgetType: 'DropdownButtonFormField');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(Size(
      constraints.maxWidth.isFinite ? constraints.maxWidth : 200.0,
      56.0,
    ));
  }
}

class DropdownButtonFormFieldElement<T> extends NativeRenderElement {
  DropdownButtonFormFieldElement(DropdownButtonFormField<T> super.widget);

  @override
  DropdownButtonFormField<T> get widget => super.widget as DropdownButtonFormField<T>;

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
      backend.registerEventListener(handle, 'select', (name, data) {
        final index = (data['index'] as num?)?.toInt() ?? 0;
        if (index >= 0 && index < widget.items.length) {
          widget.onChanged?.call(widget.items[index].value);
        }
      });
    }
  }
}
