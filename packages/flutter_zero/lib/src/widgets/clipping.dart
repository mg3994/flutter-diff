import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class ClipRect extends NativeRenderWidget {
  final Widget child;

  const ClipRect({
    super.key,
    required this.child,
  });

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'ClipRect',
    );
  }
}

class ClipRRect extends NativeRenderWidget {
  final double borderRadius;
  final Widget child;

  const ClipRRect({
    super.key,
    this.borderRadius = 8.0,
    required this.child,
  });

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'ClipRRect',
      props: {'borderRadius': borderRadius},
    );
  }
}
