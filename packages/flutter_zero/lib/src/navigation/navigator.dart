import '../core/element.dart';
import '../core/widget.dart';
import '../widgets/widgets.dart';

abstract class Route<T> {
  Widget buildContent(BuildContext context);
}

class PageRoute<T> extends Route<T> {
  final WidgetBuilder builder;

  PageRoute({required this.builder});

  @override
  Widget buildContent(BuildContext context) => builder(context);
}

typedef WidgetBuilder = Widget Function(BuildContext context);

class Navigator extends StatefulWidget {
  final List<Route<dynamic>> initialRoutes;

  const Navigator({
    super.key,
    required this.initialRoutes,
  });

  static NavigatorState of(BuildContext context) {
    final state = context.dependOnInheritedWidgetOfExactType<_NavigatorInherited>()?.state;
    if (state == null) {
      throw Exception('Navigator.of() called with a context that does not contain a Navigator.');
    }
    return state;
  }

  static void push(BuildContext context, Route<dynamic> route) {
    of(context).push(route);
  }

  static void pop(BuildContext context) {
    of(context).pop();
  }

  @override
  State<Navigator> createState() => NavigatorState();
}

class NavigatorState extends State<Navigator> {
  final List<Route<dynamic>> _history = [];

  List<Route<dynamic>> get history => List.unmodifiable(_history);

  @override
  void initState() {
    super.initState();
    _history.addAll(widget.initialRoutes);
  }

  void push(Route<dynamic> route) {
    setState(() {
      _history.add(route);
    });
  }

  bool pop() {
    if (_history.length > 1) {
      setState(() {
        _history.removeLast();
      });
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_history.isEmpty) {
      return const SizedBox();
    }
    final topRoute = _history.last;
    return _NavigatorInherited(
      state: this,
      child: topRoute.buildContent(context),
    );
  }
}

class _NavigatorInherited extends InheritedWidget {
  final NavigatorState state;

  const _NavigatorInherited({
    required this.state,
    required super.child,
  });

  @override
  bool updateShouldNotify(_NavigatorInherited oldWidget) {
    return state != oldWidget.state;
  }
}
