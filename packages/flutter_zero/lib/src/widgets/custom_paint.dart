import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class NativeCanvas {
  final List<Map<String, dynamic>> commands = [];

  void drawRect(Offset offset, Size size, String color) {
    commands.add({
      'type': 'drawRect',
      'x': offset.dx,
      'y': offset.dy,
      'width': size.width,
      'height': size.height,
      'color': color,
    });
  }

  void drawCircle(Offset center, double radius, String color) {
    commands.add({
      'type': 'drawCircle',
      'cx': center.dx,
      'cy': center.dy,
      'radius': radius,
      'color': color,
    });
  }

  void drawLine(Offset p1, Offset p2, String color, double strokeWidth) {
    commands.add({
      'type': 'drawLine',
      'x1': p1.dx,
      'y1': p1.dy,
      'x2': p2.dx,
      'y2': p2.dy,
      'color': color,
      'strokeWidth': strokeWidth,
    });
  }
}

abstract class CustomPainter {
  void paint(NativeCanvas canvas, Size size);
  bool shouldRepaint(covariant CustomPainter oldDelegate);
}

class CustomPaint extends NativeRenderWidget {
  final CustomPainter painter;
  final Size size;
  final Widget? child;

  const CustomPaint({
    super.key,
    required this.painter,
    this.size = Size.zero,
    this.child,
  });

  @override
  NativeRenderNode createRenderNode() {
    final canvas = NativeCanvas();
    painter.paint(canvas, size);

    return CustomPaintRenderNode(
      props: {
        'commands': canvas.commands,
        'sizeWidth': size.width,
        'sizeHeight': size.height,
      },
    );
  }
}

class CustomPaintRenderNode extends SingleChildNativeRenderNode {
  CustomPaintRenderNode({required super.props}) : super(widgetType: 'CustomPaint');

  @override
  void performLayout(BoxConstraints constraints) {
    final double w = (props['sizeWidth'] as num?)?.toDouble() ?? 0.0;
    final double h = (props['sizeHeight'] as num?)?.toDouble() ?? 0.0;

    final currentChild = child;
    if (currentChild != null) {
      currentChild.performLayout(constraints);
      size = constraints.constrain(Size(
        currentChild.size.width > w ? currentChild.size.width : w,
        currentChild.size.height > h ? currentChild.size.height : h,
      ));
    } else {
      size = constraints.constrain(Size(w, h));
    }
  }
}
