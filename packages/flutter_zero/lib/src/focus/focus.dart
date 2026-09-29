import '../core/element.dart';
import '../core/widget.dart';

class FocusNode {
  bool _hasFocus = false;
  final List<void Function()> _listeners = [];

  bool get hasFocus => _hasFocus;

  void requestFocus() {
    if (!_hasFocus) {
      _hasFocus = true;
      _notify();
    }
  }

  void unfocus() {
    if (_hasFocus) {
      _hasFocus = false;
      _notify();
    }
  }

  void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  void _notify() {
    for (final l in List.of(_listeners)) {
      l();
    }
  }

  void dispose() {
    _listeners.clear();
  }
}

class FocusScopeNode extends FocusNode {}

class Focus extends StatefulWidget {
  final FocusNode? focusNode;
  final Widget child;

  const Focus({
    super.key,
    this.focusNode,
    required this.child,
  });

  @override
  State<Focus> createState() => _FocusState();
}

class _FocusState extends State<Focus> {
  late FocusNode _node;

  FocusNode get node => _node;

  @override
  void initState() {
    super.initState();
    _node = widget.focusNode ?? FocusNode();
    _node.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(Focus oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode && widget.focusNode != null) {
      _node.removeListener(_handleFocusChange);
      _node = widget.focusNode!;
      _node.addListener(_handleFocusChange);
    }
  }

  void _handleFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _node.removeListener(_handleFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class FocusScope extends Focus {
  const FocusScope({
    super.key,
    super.focusNode,
    required super.child,
  });
}
