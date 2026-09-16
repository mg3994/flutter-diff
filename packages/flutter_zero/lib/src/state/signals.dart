export 'package:signals_core/signals_core.dart';

import 'package:signals_core/signals_core.dart';
import '../core/element.dart';
import '../core/widget.dart';

/// A reactive widget builder that rebuilds when the target signal changes in Flutter Zero.
class SignalBuilder<T> extends StatefulWidget {
  final ReadonlySignal<T> signal;
  final Widget Function(BuildContext context, T value) builder;

  const SignalBuilder({
    super.key,
    required this.signal,
    required this.builder,
  });

  @override
  State<SignalBuilder<T>> createState() => _SignalBuilderState<T>();
}

class _SignalBuilderState<T> extends State<SignalBuilder<T>> {
  EffectCleanup? _cleanup;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  void _subscribe() {
    _cleanup?.call();
    _cleanup = effect(() {
      widget.signal.value;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(SignalBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.signal != widget.signal) {
      _subscribe();
    }
  }

  @override
  void dispose() {
    _cleanup?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.signal.value);
  }
}

extension SignalWatchExtension<T> on ReadonlySignal<T> {
  T watch(BuildContext context) {
    return value;
  }
}

class Provided<T> extends InheritedWidget {
  final T value;

  const Provided({
    super.key,
    required this.value,
    required super.child,
  });

  static T of<T>(BuildContext context) {
    final provided = context.dependOnInheritedWidgetOfExactType<Provided<T>>();
    if (provided == null) {
      throw StateError('No Provided<$T> found in BuildContext.');
    }
    return provided.value;
  }

  @override
  bool updateShouldNotify(Provided<T> oldWidget) => value != oldWidget.value;
}
