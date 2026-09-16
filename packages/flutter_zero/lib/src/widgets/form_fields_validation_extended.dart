import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

enum AutovalidateMode {
  disabled,
  always,
  onUserInteraction,
}

typedef FormFieldWidgetBuilder<T> = Widget Function(FormFieldState<T> field);

class FormField<T> extends NativeRenderWidget {
  final FormFieldWidgetBuilder<T> builder;
  final T? initialValue;
  final String? Function(T? value)? validator;
  final AutovalidateMode autovalidateMode;

  const FormField({
    super.key,
    required this.builder,
    this.initialValue,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  @override
  Element createElement() => FormFieldElement<T>(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(widgetType: 'FormField');
  }
}

class FormFieldState<T> {
  T? value;
  String? errorText;

  FormFieldState(this.value);

  void didChange(T? newValue) {
    value = newValue;
  }
}

class FormFieldElement<T> extends NativeRenderElement {
  late FormFieldState<T> state;
  Element? _childEl;

  FormFieldElement(FormField<T> super.widget);

  @override
  FormField<T> get widget => super.widget as FormField<T>;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    state = FormFieldState<T>(widget.initialValue);
    final builtWidget = widget.builder(state);
    _childEl = builtWidget.createElement()..mount(this);
    if (_childEl?.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _childEl!.renderNode;
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childEl != null) visitor(_childEl!);
  }
}
