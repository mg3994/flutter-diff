import '../core/element.dart';
import '../core/widget.dart';
import 'gestures.dart';

class Draggable<T> extends StatelessWidget {
  final T data;
  final Widget child;
  final Widget? feedback;

  const Draggable({
    super.key,
    required this.data,
    required this.child,
    this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _activeDragData = data;
      },
      child: child,
    );
  }

  static dynamic _activeDragData;
  static dynamic get activeDragData => _activeDragData;
  static void clearActiveDrag() => _activeDragData = null;
}

class DragTarget<T> extends StatefulWidget {
  final bool Function(T? data)? onWillAccept;
  final void Function(T data)? onAccept;
  final Widget Function(BuildContext context, T? candidateData) builder;

  const DragTarget({
    super.key,
    this.onWillAccept,
    this.onAccept,
    required this.builder,
  });

  @override
  State<DragTarget<T>> createState() => _DragTargetState<T>();
}

class _DragTargetState<T> extends State<DragTarget<T>> {
  @override
  Widget build(BuildContext context) {
    final candidate = Draggable.activeDragData is T ? Draggable.activeDragData as T : null;
    return GestureDetector(
      onTap: () {
        final currentCandidate = Draggable.activeDragData is T ? Draggable.activeDragData as T : null;
        if (currentCandidate != null && (widget.onWillAccept == null || widget.onWillAccept!(currentCandidate))) {
          widget.onAccept?.call(currentCandidate);
          Draggable.clearActiveDrag();
          setState(() {});
        }
      },
      child: widget.builder(context, candidate),
    );
  }
}
