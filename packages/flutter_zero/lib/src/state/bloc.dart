import 'dart:async';
import 'package:bloc/bloc.dart';
import '../core/element.dart';
import '../core/widget.dart';

export 'package:bloc/bloc.dart';

class BlocBuilder<B extends StateStreamable<S>, S> extends StatefulWidget {
  final B bloc;
  final Widget Function(BuildContext context, S state) builder;

  const BlocBuilder({
    super.key,
    required this.bloc,
    required this.builder,
  });

  @override
  State<BlocBuilder<B, S>> createState() => _BlocBuilderState<B, S>();
}

class _BlocBuilderState<B extends StateStreamable<S>, S> extends State<BlocBuilder<B, S>> {
  StreamSubscription<S>? _subscription;
  late S _state;

  @override
  void initState() {
    super.initState();
    _state = widget.bloc.state;
    _subscribe();
  }

  void _subscribe() {
    _subscription?.cancel();
    _subscription = widget.bloc.stream.listen((state) {
      if (mounted) {
        setState(() {
          _state = state;
        });
      }
    });
  }

  @override
  void didUpdateWidget(BlocBuilder<B, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bloc != widget.bloc) {
      _state = widget.bloc.state;
      _subscribe();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _state);
  }
}
