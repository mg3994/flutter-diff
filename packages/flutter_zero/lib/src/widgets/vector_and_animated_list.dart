import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class CanvasCommand {
  final String type;
  final Map<String, dynamic> params;

  const CanvasCommand(this.type, this.params);

  Map<String, dynamic> toJson() => {
        'type': type,
        'params': params,
      };
}

typedef AnimatedItemBuilder = Widget Function(BuildContext context, int index);

class AnimatedList extends NativeRenderWidget {
  final int initialItemCount;
  final AnimatedItemBuilder itemBuilder;

  const AnimatedList({
    super.key,
    required this.initialItemCount,
    required this.itemBuilder,
  });

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'AnimatedList',
      props: {'itemCount': initialItemCount},
    );
  }
}
