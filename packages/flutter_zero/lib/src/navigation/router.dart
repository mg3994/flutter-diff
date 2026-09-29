import '../core/element.dart';
import '../core/widget.dart';
import '../widgets/widgets.dart';

typedef ZeroRouteBuilder = Widget Function(BuildContext context, Map<String, String> params);

class ZeroRoute {
  final String path;
  final ZeroRouteBuilder builder;

  const ZeroRoute({
    required this.path,
    required this.builder,
  });

  bool matches(String targetPath, Map<String, String> outParams) {
    final routeSegments = path.split('/').where((s) => s.isNotEmpty).toList();
    final targetSegments = targetPath.split('/').where((s) => s.isNotEmpty).toList();

    if (routeSegments.length != targetSegments.length) return false;

    outParams.clear();
    for (var i = 0; i < routeSegments.length; i++) {
      final r = routeSegments[i];
      final t = targetSegments[i];

      if (r.startsWith(':')) {
        outParams[r.substring(1)] = t;
      } else if (r != t) {
        return false;
      }
    }
    return true;
  }
}

class ZeroRouter extends StatefulWidget {
  final List<ZeroRoute> routes;
  final String initialPath;
  final Widget Function(BuildContext context)? notFoundBuilder;

  const ZeroRouter({
    super.key,
    required this.routes,
    required this.initialPath,
    this.notFoundBuilder,
  });

  static ZeroRouterState of(BuildContext context) {
    final state = context.dependOnInheritedWidgetOfExactType<_ZeroRouterInherited>()?.state;
    if (state == null) {
      throw Exception('ZeroRouter.of() called with a context that does not contain a ZeroRouter.');
    }
    return state;
  }

  @override
  State<ZeroRouter> createState() => ZeroRouterState();
}

class ZeroRouterState extends State<ZeroRouter> {
  late String _currentPath;

  String get currentPath => _currentPath;

  @override
  void initState() {
    super.initState();
    _currentPath = widget.initialPath;
  }

  void go(String path) {
    if (_currentPath != path) {
      setState(() {
        _currentPath = path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final params = <String, String>{};
    ZeroRoute? matchedRoute;

    for (final route in widget.routes) {
      if (route.matches(_currentPath, params)) {
        matchedRoute = route;
        break;
      }
    }

    final Widget child;
    if (matchedRoute != null) {
      child = matchedRoute.builder(context, params);
    } else if (widget.notFoundBuilder != null) {
      child = widget.notFoundBuilder!(context);
    } else {
      child = Text('404 Not Found: $_currentPath');
    }

    return _ZeroRouterInherited(
      state: this,
      child: child,
    );
  }
}

class _ZeroRouterInherited extends InheritedWidget {
  final ZeroRouterState state;

  const _ZeroRouterInherited({
    required this.state,
    required super.child,
  });

  @override
  bool updateShouldNotify(_ZeroRouterInherited oldWidget) {
    return state != oldWidget.state;
  }
}
