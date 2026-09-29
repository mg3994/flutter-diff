import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class Transform extends NativeRenderWidget {
  final double scale;
  final double rotation;
  final Offset translation;
  final Widget child;

  const Transform({
    super.key,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.translation = Offset.zero,
    required this.child,
  });

  const Transform.scale({
    super.key,
    required this.scale,
    required this.child,
  })  : rotation = 0.0,
        translation = Offset.zero;

  const Transform.rotate({
    super.key,
    required this.rotation,
    required this.child,
  })  : scale = 1.0,
        translation = Offset.zero;

  const Transform.translate({
    super.key,
    required this.translation,
    required this.child,
  })  : scale = 1.0,
        rotation = 0.0;

  @override
  NativeRenderNode createRenderNode() {
    return TransformRenderNode(
      props: {
        'scale': scale,
        'rotation': rotation,
        'dx': translation.dx,
        'dy': translation.dy,
      },
    );
  }
}

class TransformRenderNode extends SingleChildNativeRenderNode {
  TransformRenderNode({required super.props}) : super(widgetType: 'Transform');

  @override
  void performLayout(BoxConstraints constraints) {
    final currentChild = child;
    if (currentChild != null) {
      currentChild.performLayout(constraints);
      final double scale = (props['scale'] as num?)?.toDouble() ?? 1.0;
      size = constraints.constrain(Size(
        currentChild.size.width * scale,
        currentChild.size.height * scale,
      ));
    } else {
      size = constraints.constrain(Size.zero);
    }
  }
}

class RotatedBox extends StatelessWidget {
  final int quarterTurns;
  final Widget child;

  const RotatedBox({
    super.key,
    required this.quarterTurns,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final double rad = quarterTurns * 1.5707963267948966;
    return Transform.rotate(
      rotation: rad,
      child: child,
    );
  }
}
