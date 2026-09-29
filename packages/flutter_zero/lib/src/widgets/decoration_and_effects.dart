import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class BorderSide {
  final String color;
  final double width;

  const BorderSide({
    this.color = '#000000',
    this.width = 1.0,
  });

  Map<String, dynamic> toJson() => {
        'color': color,
        'width': width,
      };
}

class Border {
  final BorderSide top;
  final BorderSide right;
  final BorderSide bottom;
  final BorderSide left;

  const Border.all({
    String color = '#000000',
    double width = 1.0,
  })  : top = const BorderSide(color: color, width: width),
        right = const BorderSide(color: color, width: width),
        bottom = const BorderSide(color: color, width: width),
        left = const BorderSide(color: color, width: width);

  Map<String, dynamic> toJson() => {
        'top': top.toJson(),
        'right': right.toJson(),
        'bottom': bottom.toJson(),
        'left': left.toJson(),
      };
}

class BorderRadius {
  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;

  const BorderRadius.all(double radius)
      : topLeft = radius,
        topRight = radius,
        bottomLeft = radius,
        bottomRight = radius;

  const BorderRadius.circular(double radius)
      : topLeft = radius,
        topRight = radius,
        bottomLeft = radius,
        bottomRight = radius;

  Map<String, dynamic> toJson() => {
        'topLeft': topLeft,
        'topRight': topRight,
        'bottomLeft': bottomLeft,
        'bottomRight': bottomRight,
      };
}

class BoxShadow {
  final String color;
  final double blurRadius;

  const BoxShadow({
    this.color = '#000000',
    this.blurRadius = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'color': color,
        'blurRadius': blurRadius,
      };
}

class BoxDecoration {
  final String? color;
  final Border? border;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;

  const BoxDecoration({
    this.color,
    this.border,
    this.borderRadius,
    this.boxShadow,
  });

  Map<String, dynamic> toJson() => {
        if (color != null) 'color': color,
        if (border != null) 'border': border!.toJson(),
        if (borderRadius != null) 'borderRadius': borderRadius!.toJson(),
        if (boxShadow != null)
          'boxShadow': boxShadow!.map((s) => s.toJson()).toList(),
      };
}

class DecoratedBox extends NativeRenderWidget {
  final BoxDecoration decoration;
  final Widget? child;

  const DecoratedBox({
    super.key,
    required this.decoration,
    this.child,
  });

  @override
  Element createElement() => DecoratedBoxElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'DecoratedBox',
      props: {'decoration': decoration.toJson()},
    );
  }
}

class DecoratedBoxElement extends NativeRenderElement {
  Element? _childEl;

  DecoratedBoxElement(DecoratedBox super.widget);

  @override
  DecoratedBox get widget => super.widget as DecoratedBox;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    if (widget.child != null) {
      _childEl = widget.child!.createElement()..mount(this);
      if (_childEl?.renderNode != null) {
        (renderNode as SingleChildNativeRenderNode).child = _childEl!.renderNode;
      }
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childEl != null) visitor(_childEl!);
  }
}

class ColoredBox extends NativeRenderWidget {
  final String color;
  final Widget? child;

  const ColoredBox({
    super.key,
    required this.color,
    this.child,
  });

  @override
  Element createElement() => ColoredBoxElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'ColoredBox',
      props: {'color': color},
    );
  }
}

class ColoredBoxElement extends NativeRenderElement {
  Element? _childEl;

  ColoredBoxElement(ColoredBox super.widget);

  @override
  ColoredBox get widget => super.widget as ColoredBox;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    if (widget.child != null) {
      _childEl = widget.child!.createElement()..mount(this);
      if (_childEl?.renderNode != null) {
        (renderNode as SingleChildNativeRenderNode).child = _childEl!.renderNode;
      }
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childEl != null) visitor(_childEl!);
  }
}
