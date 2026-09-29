import '../core/element.dart';
import '../core/widget.dart';
import 'widgets.dart';

typedef FormFieldValidator<T> = String? Function(T? value);
typedef FormFieldSetter<T> = void Function(T? newValue);

class Form extends StatefulWidget {
  final Widget child;

  const Form({
    super.key,
    required this.child,
  });

  static FormState? of(BuildContext context) {
    final element = context.dependOnInheritedWidgetOfExactType<_FormScope>();
    return element?.state;
  }

  @override
  State<Form> createState() => FormState();
}

class FormState extends State<Form> {
  final Set<FormFieldState<dynamic>> _fields = {};

  void _register(FormFieldState<dynamic> field) {
    _fields.add(field);
  }

  void _unregister(FormFieldState<dynamic> field) {
    _fields.remove(field);
  }

  bool validate() {
    bool hasError = false;
    for (final field in _fields) {
      if (!field.validate()) {
        hasError = true;
      }
    }
    return !hasError;
  }

  void save() {
    for (final field in _fields) {
      field.save();
    }
  }

  void reset() {
    for (final field in _fields) {
      field.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FormScope(
      state: this,
      child: widget.child,
    );
  }
}

class _FormScope extends InheritedWidget {
  final FormState state;

  const _FormScope({
    required this.state,
    required super.child,
  });

  @override
  bool updateShouldNotify(_FormScope oldWidget) => state != oldWidget.state;
}

abstract class FormField<T> extends StatefulWidget {
  final FormFieldValidator<T>? validator;
  final FormFieldSetter<T>? onSaved;
  final T? initialValue;

  const FormField({
    super.key,
    this.validator,
    this.onSaved,
    this.initialValue,
  });

  @override
  FormFieldState<T> createState();
}

abstract class FormFieldState<T> extends State<FormField<T>> {
  late T? _value;
  String? _errorText;

  T? get value => _value;
  String? get errorText => _errorText;
  bool get hasError => _errorText != null;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void didChange(T? newValue) {
    setState(() {
      _value = newValue;
    });
  }

  bool validate() {
    if (widget.validator != null) {
      final error = widget.validator!(_value);
      setState(() {
        _errorText = error;
      });
      return error == null;
    }
    return true;
  }

  void save() {
    widget.onSaved?.call(_value);
  }

  void reset() {
    setState(() {
      _value = widget.initialValue;
      _errorText = null;
    });
  }

  @override
  void dispose() {
    Form.of(context)?._unregister(this);
    super.dispose();
  }
}

class TextFormField extends FormField<String> {
  final String? placeholder;

  const TextFormField({
    super.key,
    super.validator,
    super.onSaved,
    super.initialValue,
    this.placeholder,
  });

  @override
  FormFieldState<String> createState() => _TextFormFieldState();
}

class _TextFormFieldState extends FormFieldState<String> {
  @override
  TextFormField get widget => super.widget as TextFormField;

  @override
  void initState() {
    super.initState();
    Form.of(context)?._register(this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          placeholder: widget.placeholder,
          initialValue: value,
          onChanged: (val) {
            didChange(val);
          },
        ),
        if (hasError)
          Text(
            errorText!,
            color: '#FF0000',
            fontSize: 12.0,
          ),
      ],
    );
  }
}
