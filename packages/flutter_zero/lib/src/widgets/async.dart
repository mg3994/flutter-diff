import 'dart:async';
import '../core/element.dart';
import '../core/widget.dart';

enum ConnectionState { none, waiting, active, done }

class AsyncSnapshot<T> {
  final ConnectionState connectionState;
  final T? data;
  final Object? error;

  const AsyncSnapshot._(this.connectionState, this.data, this.error);

  const AsyncSnapshot.nothing() : this._(ConnectionState.none, null, null);
  const AsyncSnapshot.waiting() : this._(ConnectionState.waiting, null, null);
  const AsyncSnapshot.withData(ConnectionState state, T data) : this._(state, data, null);
  const AsyncSnapshot.withError(ConnectionState state, Object error) : this._(state, null, error);

  bool get hasData => data != null;
  bool get hasError => error != null;
}

class FutureBuilder<T> extends StatefulWidget {
  final Future<T>? future;
  final T? initialData;
  final Widget Function(BuildContext context, AsyncSnapshot<T> snapshot) builder;

  const FutureBuilder({
    super.key,
    this.future,
    this.initialData,
    required this.builder,
  });

  @override
  State<FutureBuilder<T>> createState() => _FutureBuilderState<T>();
}

class _FutureBuilderState<T> extends State<FutureBuilder<T>> {
  late AsyncSnapshot<T> _snapshot;

  @override
  void initState() {
    super.initState();
    _snapshot = widget.initialData != null
        ? AsyncSnapshot.withData(ConnectionState.none, widget.initialData as T)
        : const AsyncSnapshot.nothing();
    _subscribe();
  }

  @override
  void didUpdateWidget(FutureBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.future != widget.future) {
      _subscribe();
    }
  }

  void _subscribe() {
    if (widget.future != null) {
      _snapshot = _snapshot.hasData
          ? AsyncSnapshot.withData(ConnectionState.waiting, _snapshot.data as T)
          : const AsyncSnapshot.waiting();
      widget.future!.then((T data) {
        if (mounted) {
          setState(() {
            _snapshot = AsyncSnapshot.withData(ConnectionState.done, data);
          });
        }
      }, onError: (Object error) {
        if (mounted) {
          setState(() {
            _snapshot = AsyncSnapshot.withError(ConnectionState.done, error);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _snapshot);
  }
}

class StreamBuilder<T> extends StatefulWidget {
  final Stream<T>? stream;
  final T? initialData;
  final Widget Function(BuildContext context, AsyncSnapshot<T> snapshot) builder;

  const StreamBuilder({
    super.key,
    this.stream,
    this.initialData,
    required this.builder,
  });

  @override
  State<StreamBuilder<T>> createState() => _StreamBuilderState<T>();
}

class _StreamBuilderState<T> extends State<StreamBuilder<T>> {
  StreamSubscription<T>? _subscription;
  late AsyncSnapshot<T> _snapshot;

  @override
  void initState() {
    super.initState();
    _snapshot = widget.initialData != null
        ? AsyncSnapshot.withData(ConnectionState.none, widget.initialData as T)
        : const AsyncSnapshot.nothing();
    _subscribe();
  }

  @override
  void didUpdateWidget(StreamBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      _unsubscribe();
      _subscribe();
    }
  }

  void _subscribe() {
    if (widget.stream != null) {
      _snapshot = _snapshot.hasData
          ? AsyncSnapshot.withData(ConnectionState.waiting, _snapshot.data as T)
          : const AsyncSnapshot.waiting();
      _subscription = widget.stream!.listen((T data) {
        if (mounted) {
          setState(() {
            _snapshot = AsyncSnapshot.withData(ConnectionState.active, data);
          });
        }
      }, onError: (Object error) {
        if (mounted) {
          setState(() {
            _snapshot = AsyncSnapshot.withError(ConnectionState.active, error);
          });
        }
      }, onDone: () {
        if (mounted) {
          setState(() {
            _snapshot = _snapshot.hasData
                ? AsyncSnapshot.withData(ConnectionState.done, _snapshot.data as T)
                : const AsyncSnapshot.withError(ConnectionState.done, 'Done');
          });
        }
      });
    }
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _snapshot);
  }
}
