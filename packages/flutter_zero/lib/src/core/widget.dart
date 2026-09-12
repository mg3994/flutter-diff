import 'element.dart';

abstract class Key {
  const factory Key(String value) = ValueKey<String>;
  const Key._();
}

class ValueKey<T> extends Key {
  final T value;
  const ValueKey(this.value) : super._();

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is ValueKey<T> && other.value == value;
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() => '[$value]';
}

class GlobalKey<T extends State<StatefulWidget>> extends Key {
  static final Map<GlobalKey<dynamic>, StatefulElement> _registry = {};

  const GlobalKey() : super._();

  T? get currentState => _registry[this]?.state as T?;
  BuildContext? get currentContext => _registry[this];
  Widget? get currentWidget => _registry[this]?.widget;

  static void register(GlobalKey<dynamic> key, StatefulElement element) {
    _registry[key] = element;
  }

  static void unregister(GlobalKey<dynamic> key) {
    _registry.remove(key);
  }
}

abstract class Widget {
  final Key? key;

  const Widget({this.key});

  Element createElement();

  static bool canUpdate(Widget oldWidget, Widget newWidget) {
    return oldWidget.runtimeType == newWidget.runtimeType &&
        oldWidget.key == newWidget.key;
  }
}

abstract class StatelessWidget extends Widget {
  const StatelessWidget({super.key});

  @override
  Element createElement() => StatelessElement(this);

  Widget build(BuildContext context);
}

abstract class StatefulWidget extends Widget {
  const StatefulWidget({super.key});

  @override
  Element createElement() => StatefulElement(this);

  State createState();
}

abstract class State<T extends StatefulWidget> {
  T get widget => _widget!;
  T? _widget;

  BuildContext get context => _element!;
  StatefulElement? _element;

  bool get mounted => _element != null;

  void initState() {}

  void didUpdateWidget(T oldWidget) {}

  void dispose() {}

  void setState(void Function() fn) {
    fn();
    _element?.markNeedsBuild();
  }

  Widget build(BuildContext context);

  void attachElement(StatefulElement element, T widget) {
    _element = element;
    _widget = widget;
  }

  void detachElement() {
    _element = null;
  }

  void updateWidget(T newWidget) {
    _widget = newWidget;
  }
}

abstract class InheritedWidget extends Widget {
  final Widget child;
  const InheritedWidget({super.key, required this.child});

  @override
  Element createElement() => InheritedElement(this);

  bool updateShouldNotify(covariant InheritedWidget oldWidget);
}

abstract class SingleChildRenderObjectWidget extends Widget {
  final Widget? child;
  const SingleChildRenderObjectWidget({super.key, this.child});
}

abstract class MultiChildRenderObjectWidget extends Widget {
  final List<Widget> children;
  const MultiChildRenderObjectWidget({super.key, this.children = const []});
}
