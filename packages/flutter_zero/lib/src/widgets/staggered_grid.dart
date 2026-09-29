import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class NativeStaggeredGrid extends NativeRenderWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  const NativeStaggeredGrid({
    super.key,
    this.children = const [],
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
  });

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'NativeStaggeredGrid',
      props: {
        'crossAxisCount': crossAxisCount,
        'mainAxisSpacing': mainAxisSpacing,
        'crossAxisSpacing': crossAxisSpacing,
      },
    );
  }
}
