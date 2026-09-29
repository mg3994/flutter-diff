import '../core/element.dart';
import '../core/widget.dart';

class Provider<T> extends InheritedWidget {
  final T value;

  const Provider({
    super.key,
    required this.value,
    required super.child,
  });

  static T of<T>(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<Provider<T>>();
    if (provider == null) {
      throw Exception('Provider.of() called with a context that does not contain Provider<$T>.');
    }
    return provider.value;
  }

  @override
  bool updateShouldNotify(Provider<T> oldWidget) {
    return value != oldWidget.value;
  }
}

class Consumer<T> extends StatelessWidget {
  final Widget Function(BuildContext context, T value, Widget? child) builder;
  final Widget? child;

  const Consumer({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<T>(context);
    return builder(context, value, child);
  }
}
