import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class Image extends NativeRenderWidget {
  final String src;
  final double? width;
  final double? height;
  final String? fit;

  const Image({
    super.key,
    required this.src,
    this.width,
    this.height,
    this.fit,
  });

  factory Image.network(
    String url, {
    Key? key,
    double? width,
    double? height,
    String? fit,
  }) {
    return Image(
      key: key,
      src: url,
      width: width,
      height: height,
      fit: fit,
    );
  }

  factory Image.asset(
    String name, {
    Key? key,
    double? width,
    double? height,
    String? fit,
  }) {
    return Image(
      key: key,
      src: 'asset://$name',
      width: width,
      height: height,
      fit: fit,
    );
  }

  @override
  NativeRenderNode createRenderNode() {
    return ImageRenderNode(
      props: {
        'src': src,
        if (width != null) 'width': width,
        if (height != null) 'height': height,
        if (fit != null) 'fit': fit,
      },
    );
  }
}

class ImageRenderNode extends NativeRenderNode {
  ImageRenderNode({required super.props}) : super(widgetType: 'Image');

  @override
  void performLayout(BoxConstraints constraints) {
    final double? w = props['width'] as double?;
    final double? h = props['height'] as double?;

    size = constraints.constrain(Size(
      w ?? (constraints.maxWidth.isFinite ? constraints.maxWidth : 100.0),
      h ?? (constraints.maxHeight.isFinite ? constraints.maxHeight : 100.0),
    ));
  }
}
