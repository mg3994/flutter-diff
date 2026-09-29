import '../core/element.dart';
import '../core/widget.dart';
import '../widgets/widgets.dart';
import 'animation.dart';

class AnimatedBuilder extends StatelessWidget {
  final Animation<double> animation;
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}

class AnimatedContainer extends StatefulWidget {
  final double? width;
  final double? height;
  final String? backgroundColor;
  final Duration duration;
  final Widget? child;

  const AnimatedContainer({
    super.key,
    this.width,
    this.height,
    this.backgroundColor,
    required this.duration,
    this.child,
  });

  @override
  State<AnimatedContainer> createState() => _AnimatedContainerState();
}

class _AnimatedContainerState extends State<AnimatedContainer> {
  late double? _currentWidth;
  late double? _currentHeight;

  @override
  void initState() {
    super.initState();
    _currentWidth = widget.width;
    _currentHeight = widget.height;
  }

  @override
  void didUpdateWidget(AnimatedContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.width != widget.width || oldWidget.height != widget.height) {
      setState(() {
        _currentWidth = widget.width;
        _currentHeight = widget.height;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _currentWidth,
      height: _currentHeight,
      backgroundColor: widget.backgroundColor,
      child: widget.child,
    );
  }
}
