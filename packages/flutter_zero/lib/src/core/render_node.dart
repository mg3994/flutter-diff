class Size {
  final double width;
  final double height;

  const Size(this.width, this.height);
  static const Size zero = Size(0, 0);

  @override
  String toString() => 'Size(${width.toStringAsFixed(1)}, ${height.toStringAsFixed(1)})';

  @override
  bool operator ==(Object other) =>
      other is Size && other.width == width && other.height == height;

  @override
  int get hashCode => Object.hash(width, height);
}

class Offset {
  final double dx;
  final double dy;

  const Offset(this.dx, this.dy);
  static const Offset zero = Offset(0, 0);

  @override
  String toString() => 'Offset(${dx.toStringAsFixed(1)}, ${dy.toStringAsFixed(1)})';

  @override
  bool operator ==(Object other) =>
      other is Offset && other.dx == dx && other.dy == dy;

  @override
  int get hashCode => Object.hash(dx, dy);
}

class BoxConstraints {
  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;

  const BoxConstraints({
    this.minWidth = 0.0,
    this.maxWidth = double.infinity,
    this.minHeight = 0.0,
    this.maxHeight = double.infinity,
  });

  Size constrain(Size size) {
    return Size(
      size.width.clamp(minWidth, maxWidth),
      size.height.clamp(minHeight, maxHeight),
    );
  }

  @override
  String toString() =>
      'BoxConstraints($minWidth <= w <= $maxWidth, $minHeight <= h <= $maxHeight)';
}

abstract class NativeRenderNode {
  int? nativeHandle;
  String widgetType;
  Map<String, dynamic> props;
  void Function(int handle)? onNativeHandleCreated;

  Offset offset = Offset.zero;
  Size size = Size.zero;

  NativeRenderNode? parent;
  final List<NativeRenderNode> children = [];

  NativeRenderNode({
    required this.widgetType,
    Map<String, dynamic>? props,
  }) : props = props ?? {};

  void addChild(NativeRenderNode child) {
    child.parent = this;
    children.add(child);
  }

  void removeChild(NativeRenderNode child) {
    child.parent = null;
    children.remove(child);
  }

  void performLayout(BoxConstraints constraints);

  void updateProps(Map<String, dynamic> newProps) {
    props = Map<String, dynamic>.from(newProps);
  }
}

class SingleChildNativeRenderNode extends NativeRenderNode {
  SingleChildNativeRenderNode({required super.widgetType, super.props});

  NativeRenderNode? get child => children.isNotEmpty ? children.first : null;

  set child(NativeRenderNode? value) {
    children.clear();
    if (value != null) {
      addChild(value);
    }
  }

  @override
  void performLayout(BoxConstraints constraints) {
    final currentChild = child;
    if (currentChild != null) {
      currentChild.performLayout(constraints);
      size = constraints.constrain(currentChild.size);
    } else {
      size = constraints.constrain(Size.zero);
    }
  }
}

class MultiChildNativeRenderNode extends NativeRenderNode {
  MultiChildNativeRenderNode({required super.widgetType, super.props});

  @override
  void performLayout(BoxConstraints constraints) {
    double totalHeight = 0.0;
    double maxWidth = 0.0;

    for (final child in children) {
      child.performLayout(constraints);
      child.offset = Offset(0, totalHeight);
      totalHeight += child.size.height;
      if (child.size.width > maxWidth) {
        maxWidth = child.size.width;
      }
    }

    size = constraints.constrain(Size(maxWidth, totalHeight));
  }
}
