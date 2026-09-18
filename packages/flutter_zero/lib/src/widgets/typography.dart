import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class TextSpan {
  final String? text;
  final String? color;
  final double? fontSize;
  final List<TextSpan> children;

  const TextSpan({
    this.text,
    this.color,
    this.fontSize,
    this.children = const [],
  });

  Map<String, dynamic> toJson() => {
        if (text != null) 'text': text,
        if (color != null) 'color': color,
        if (fontSize != null) 'fontSize': fontSize,
        if (children.isNotEmpty)
          'children': children.map((c) => c.toJson()).toList(),
      };
}

class RichText extends NativeRenderWidget {
  final TextSpan text;

  const RichText({
    super.key,
    required this.text,
  });

  @override
  Element createElement() => RichTextElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return RichTextRenderNode(
      props: {'textSpan': text.toJson()},
    );
  }
}

class RichTextRenderNode extends NativeRenderNode {
  RichTextRenderNode({required super.props}) : super(widgetType: 'RichText');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(Size(
      constraints.maxWidth.isFinite ? constraints.maxWidth : 200.0,
      24.0,
    ));
  }
}

class RichTextElement extends NativeRenderElement {
  RichTextElement(RichText super.widget);
}

class SelectableText extends NativeRenderWidget {
  final String data;
  final double? fontSize;
  final String? color;

  const SelectableText(
    this.data, {
    super.key,
    this.fontSize,
    this.color,
  });

  @override
  Element createElement() => SelectableTextElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SelectableTextRenderNode(
      props: {
        'text': data,
        if (fontSize != null) 'fontSize': fontSize,
        if (color != null) 'color': color,
      },
    );
  }
}

class SelectableTextRenderNode extends NativeRenderNode {
  SelectableTextRenderNode({required super.props})
      : super(widgetType: 'SelectableText');

  @override
  void performLayout(BoxConstraints constraints) {
    final String text = props['text'] as String? ?? '';
    final double fontSize = (props['fontSize'] as num?)?.toDouble() ?? 14.0;
    size = constraints.constrain(Size(text.length * (fontSize * 0.6), fontSize * 1.2));
  }
}

class SelectableTextElement extends NativeRenderElement {
  SelectableTextElement(SelectableText super.widget);
}
