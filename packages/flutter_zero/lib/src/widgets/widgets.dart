import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'theme.dart';

abstract class NativeRenderWidget extends Widget {
  const NativeRenderWidget({super.key});

  @override
  Element createElement() => NativeRenderElement(this);

  NativeRenderNode createRenderNode();
}

class NativeRenderElement extends Element {
  NativeRenderElement(NativeRenderWidget super.widget);

  @override
  NativeRenderWidget get widget => super.widget as NativeRenderWidget;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    renderNode = widget.createRenderNode();
  }

  @override
  void update(Widget newWidget) {
    updateWidget(newWidget);
    if (renderNode != null && newWidget is NativeRenderWidget) {
      final newNode = newWidget.createRenderNode();
      renderNode!.updateProps(newNode.props);
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {}
}

class Container extends NativeRenderWidget {
  final double? width;
  final double? height;
  final String? backgroundColor;
  final Widget? child;

  const Container({
    super.key,
    this.width,
    this.height,
    this.backgroundColor,
    this.child,
  });

  @override
  Element createElement() => ContainerElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'Container',
      props: {
        if (width != null) 'width': width,
        if (height != null) 'height': height,
        if (backgroundColor != null) 'backgroundColor': backgroundColor,
      },
    );
  }
}

class ContainerElement extends NativeRenderElement {
  Element? _childElement;

  ContainerElement(Container super.widget);

  @override
  Container get widget => super.widget as Container;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final childWidget = widget.child;
    if (childWidget != null) {
      _childElement = childWidget.createElement();
      _childElement!.mount(this);
      if (_childElement!.renderNode != null) {
        (renderNode as SingleChildNativeRenderNode).child = _childElement!.renderNode;
      }
    }
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    final newContainer = newWidget as Container;
    final newChildWidget = newContainer.child;
    final currentChild = _childElement;

    if (currentChild == null && newChildWidget != null) {
      _childElement = newChildWidget.createElement();
      _childElement!.mount(this);
    } else if (currentChild != null && newChildWidget == null) {
      currentChild.unmount();
      _childElement = null;
    } else if (currentChild != null && newChildWidget != null) {
      if (Widget.canUpdate(currentChild.widget, newChildWidget)) {
        currentChild.update(newChildWidget);
      } else {
        currentChild.unmount();
        _childElement = newChildWidget.createElement();
        _childElement!.mount(this);
      }
    }

    final singleNode = renderNode as SingleChildNativeRenderNode;
    singleNode.child = _childElement?.renderNode;
  }

  @override
  void unmount() {
    _childElement?.unmount();
    _childElement = null;
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}

class Text extends NativeRenderWidget {
  final String text;
  final double? fontSize;
  final String? color;

  const Text(
    this.text, {
    super.key,
    this.fontSize,
    this.color,
  });

  @override
  Element createElement() => TextElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return TextRenderNode(
      props: {
        'text': text,
        'fontSize': fontSize,
        'color': color,
      },
    );
  }
}

class TextElement extends NativeRenderElement {
  TextElement(Text super.widget);

  @override
  Text get widget => super.widget as Text;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _applyThemeDefaults();
  }

  void _applyThemeDefaults() {
    final textWidget = widget;
    final theme = Theme.of(this);

    renderNode?.props['color'] = textWidget.color ?? theme.primaryColor;
    renderNode?.props['fontSize'] = textWidget.fontSize ?? theme.defaultFontSize;
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    _applyThemeDefaults();
  }
}

class TextRenderNode extends NativeRenderNode {
  TextRenderNode({required super.props}) : super(widgetType: 'Text');

  @override
  void performLayout(BoxConstraints constraints) {
    final String text = props['text'] as String? ?? '';
    final double fontSize = (props['fontSize'] as num?)?.toDouble() ?? 14.0;
    final double estimatedWidth = text.length * (fontSize * 0.6);
    final double estimatedHeight = fontSize * 1.2;
    size = constraints.constrain(Size(estimatedWidth, estimatedHeight));
  }
}

class Button extends NativeRenderWidget {
  final Widget child;
  final void Function()? onPressed;

  const Button({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Element createElement() => ButtonElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'Button',
      props: {'enabled': onPressed != null},
    );
  }
}

class ButtonElement extends NativeRenderElement {
  Element? _childElement;

  ButtonElement(Button super.widget);

  @override
  Button get widget => super.widget as Button;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _childElement = widget.child.createElement();
    _childElement!.mount(this);
    if (_childElement!.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _childElement!.renderNode;
    }
    _registerEvents();
  }

  void _registerEvents() {
    final handle = renderNode?.nativeHandle;
    final backend = appOwner?.backend;
    if (handle != null && backend != null && widget.onPressed != null) {
      backend.registerEventListener(handle, 'click', (eventName, data) {
        widget.onPressed?.call();
      });
    }
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    final newButton = newWidget as Button;
    final currentChild = _childElement;
    if (currentChild != null) {
      if (Widget.canUpdate(currentChild.widget, newButton.child)) {
        currentChild.update(newButton.child);
      } else {
        currentChild.unmount();
        _childElement = newButton.child.createElement();
        _childElement!.mount(this);
      }
    }
    (renderNode as SingleChildNativeRenderNode).child = _childElement?.renderNode;
    _registerEvents();
  }

  @override
  void unmount() {
    _childElement?.unmount();
    _childElement = null;
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}

class TextField extends NativeRenderWidget {
  final String? placeholder;
  final String? initialValue;
  final void Function(String text)? onChanged;

  const TextField({
    super.key,
    this.placeholder,
    this.initialValue,
    this.onChanged,
  });

  @override
  Element createElement() => TextFieldElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return TextFieldRenderNode(
      props: {
        if (placeholder != null) 'placeholder': placeholder,
        if (initialValue != null) 'value': initialValue,
      },
    );
  }
}

class TextFieldElement extends NativeRenderElement {
  TextFieldElement(TextField super.widget);

  @override
  TextField get widget => super.widget as TextField;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _registerEvents();
  }

  void _registerEvents() {
    final handle = renderNode?.nativeHandle;
    final backend = appOwner?.backend;
    if (handle != null && backend != null && widget.onChanged != null) {
      backend.registerEventListener(handle, 'change', (eventName, data) {
        final newText = data['text'] as String? ?? '';
        widget.onChanged?.call(newText);
      });
    }
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    _registerEvents();
  }
}

class TextFieldRenderNode extends NativeRenderNode {
  TextFieldRenderNode({required super.props}) : super(widgetType: 'TextField');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(const Size(200.0, 40.0));
  }
}

class Padding extends NativeRenderWidget {
  final double padding;
  final Widget child;

  const Padding({
    super.key,
    required this.padding,
    required this.child,
  });

  @override
  Element createElement() => PaddingElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return PaddingRenderNode(props: {'padding': padding});
  }
}

class PaddingRenderNode extends SingleChildNativeRenderNode {
  PaddingRenderNode({required super.props}) : super(widgetType: 'Padding');

  @override
  void performLayout(BoxConstraints constraints) {
    final double p = (props['padding'] as num?)?.toDouble() ?? 0.0;
    final double doubleP = p * 2;

    final childConstraints = BoxConstraints(
      minWidth: (constraints.minWidth - doubleP).clamp(0.0, double.infinity),
      maxWidth: (constraints.maxWidth - doubleP).clamp(0.0, double.infinity),
      minHeight: (constraints.minHeight - doubleP).clamp(0.0, double.infinity),
      maxHeight: (constraints.maxHeight - doubleP).clamp(0.0, double.infinity),
    );

    final currentChild = child;
    if (currentChild != null) {
      currentChild.performLayout(childConstraints);
      currentChild.offset = Offset(p, p);
      size = constraints.constrain(Size(
        currentChild.size.width + doubleP,
        currentChild.size.height + doubleP,
      ));
    } else {
      size = constraints.constrain(Size(doubleP, doubleP));
    }
  }
}

class PaddingElement extends NativeRenderElement {
  Element? _childElement;

  PaddingElement(Padding super.widget);

  @override
  Padding get widget => super.widget as Padding;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _childElement = widget.child.createElement();
    _childElement!.mount(this);
    if (_childElement!.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _childElement!.renderNode;
    }
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    final newPaddingWidget = newWidget as Padding;
    final currentChild = _childElement;
    if (currentChild != null) {
      if (Widget.canUpdate(currentChild.widget, newPaddingWidget.child)) {
        currentChild.update(newPaddingWidget.child);
      } else {
        currentChild.unmount();
        _childElement = newPaddingWidget.child.createElement();
        _childElement!.mount(this);
      }
    }
    (renderNode as SingleChildNativeRenderNode).child = _childElement?.renderNode;
  }

  @override
  void unmount() {
    _childElement?.unmount();
    _childElement = null;
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}

class Center extends NativeRenderWidget {
  final Widget child;

  const Center({super.key, required this.child});

  @override
  Element createElement() => CenterElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return CenterRenderNode();
  }
}

class CenterRenderNode extends SingleChildNativeRenderNode {
  CenterRenderNode() : super(widgetType: 'Center');

  @override
  void performLayout(BoxConstraints constraints) {
    final currentChild = child;
    final double maxW = constraints.maxWidth.isFinite ? constraints.maxWidth : 0.0;
    final double maxH = constraints.maxHeight.isFinite ? constraints.maxHeight : 0.0;

    if (currentChild != null) {
      currentChild.performLayout(BoxConstraints(maxWidth: maxW, maxHeight: maxH));
      final double dx = (maxW - currentChild.size.width) / 2;
      final double dy = (maxH - currentChild.size.height) / 2;
      currentChild.offset = Offset(dx > 0 ? dx : 0, dy > 0 ? dy : 0);
      size = constraints.constrain(Size(maxW, maxH));
    } else {
      size = constraints.constrain(Size(maxW, maxH));
    }
  }
}

class CenterElement extends NativeRenderElement {
  Element? _childElement;

  CenterElement(Center super.widget);

  @override
  Center get widget => super.widget as Center;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _childElement = widget.child.createElement();
    _childElement!.mount(this);
    if (_childElement!.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _childElement!.renderNode;
    }
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    final newCenter = newWidget as Center;
    final currentChild = _childElement;
    if (currentChild != null) {
      if (Widget.canUpdate(currentChild.widget, newCenter.child)) {
        currentChild.update(newCenter.child);
      } else {
        currentChild.unmount();
        _childElement = newCenter.child.createElement();
        _childElement!.mount(this);
      }
    }
    (renderNode as SingleChildNativeRenderNode).child = _childElement?.renderNode;
  }

  @override
  void unmount() {
    _childElement?.unmount();
    _childElement = null;
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}

class SizedBox extends NativeRenderWidget {
  final double? width;
  final double? height;
  final Widget? child;

  const SizedBox({super.key, this.width, this.height, this.child});

  const SizedBox.square({super.key, double? dimension, this.child})
      : width = dimension,
        height = dimension;

  @override
  Element createElement() => SizedBoxElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SizedBoxRenderNode(
      props: {
        if (width != null) 'width': width,
        if (height != null) 'height': height,
      },
    );
  }
}

class SizedBoxRenderNode extends SingleChildNativeRenderNode {
  SizedBoxRenderNode({required super.props}) : super(widgetType: 'SizedBox');

  @override
  void performLayout(BoxConstraints constraints) {
    final double? w = props['width'] as double?;
    final double? h = props['height'] as double?;

    final currentChild = child;
    if (currentChild != null) {
      currentChild.performLayout(BoxConstraints(
        minWidth: w ?? constraints.minWidth,
        maxWidth: w ?? constraints.maxWidth,
        minHeight: h ?? constraints.minHeight,
        maxHeight: h ?? constraints.maxHeight,
      ));
      size = constraints.constrain(Size(
        w ?? currentChild.size.width,
        h ?? currentChild.size.height,
      ));
    } else {
      size = constraints.constrain(Size(w ?? 0.0, h ?? 0.0));
    }
  }
}

class SizedBoxElement extends NativeRenderElement {
  Element? _childElement;

  SizedBoxElement(SizedBox super.widget);

  @override
  SizedBox get widget => super.widget as SizedBox;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final childWidget = widget.child;
    if (childWidget != null) {
      _childElement = childWidget.createElement();
      _childElement!.mount(this);
      if (_childElement!.renderNode != null) {
        (renderNode as SingleChildNativeRenderNode).child = _childElement!.renderNode;
      }
    }
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    final newSizedBox = newWidget as SizedBox;
    final newChildWidget = newSizedBox.child;
    final currentChild = _childElement;

    if (currentChild == null && newChildWidget != null) {
      _childElement = newChildWidget.createElement();
      _childElement!.mount(this);
    } else if (currentChild != null && newChildWidget == null) {
      currentChild.unmount();
      _childElement = null;
    } else if (currentChild != null && newChildWidget != null) {
      if (Widget.canUpdate(currentChild.widget, newChildWidget)) {
        currentChild.update(newChildWidget);
      } else {
        currentChild.unmount();
        _childElement = newChildWidget.createElement();
        _childElement!.mount(this);
      }
    }

    final singleNode = renderNode as SingleChildNativeRenderNode;
    singleNode.child = _childElement?.renderNode;
  }

  @override
  void unmount() {
    _childElement?.unmount();
    _childElement = null;
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}

class Row extends NativeRenderWidget {
  final List<Widget> children;

  const Row({super.key, this.children = const []});

  @override
  Element createElement() => RowElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return RowRenderNode();
  }
}

class RowRenderNode extends MultiChildNativeRenderNode {
  RowRenderNode() : super(widgetType: 'Row');

  @override
  void performLayout(BoxConstraints constraints) {
    double totalWidth = 0.0;
    double maxHeight = 0.0;

    for (final child in children) {
      child.performLayout(constraints);
      child.offset = Offset(totalWidth, 0);
      totalWidth += child.size.width;
      if (child.size.height > maxHeight) {
        maxHeight = child.size.height;
      }
    }

    size = constraints.constrain(Size(totalWidth, maxHeight));
  }
}

class RowElement extends NativeRenderElement {
  List<Element> _childElements = [];

  RowElement(Row super.widget);

  @override
  Row get widget => super.widget as Row;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;
    _childElements = widget.children.map((w) {
      final el = w.createElement();
      el.mount(this);
      if (el.renderNode != null) {
        if (w is Flexible) {
          el.renderNode!.props['flex'] = w.flex;
        }
        multiNode.addChild(el.renderNode!);
      }
      return el;
    }).toList();
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    final newRow = newWidget as Row;
    final multiNode = renderNode as MultiChildNativeRenderNode;
    final newChildrenWidgets = newRow.children;

    final List<Element> newChildElements = [];
    multiNode.children.clear();

    final int minLength = _childElements.length < newChildrenWidgets.length
        ? _childElements.length
        : newChildrenWidgets.length;

    for (int i = 0; i < minLength; i++) {
      final oldEl = _childElements[i];
      final newW = newChildrenWidgets[i];
      if (Widget.canUpdate(oldEl.widget, newW)) {
        oldEl.update(newW);
        newChildElements.add(oldEl);
      } else {
        oldEl.unmount();
        final newEl = newW.createElement();
        newEl.mount(this);
        newChildElements.add(newEl);
      }
    }

    if (_childElements.length > newChildrenWidgets.length) {
      for (int i = minLength; i < _childElements.length; i++) {
        _childElements[i].unmount();
      }
    } else if (newChildrenWidgets.length > _childElements.length) {
      for (int i = minLength; i < newChildrenWidgets.length; i++) {
        final newEl = newChildrenWidgets[i].createElement();
        newEl.mount(this);
        newChildElements.add(newEl);
      }
    }

    _childElements = newChildElements;
    for (final el in _childElements) {
      if (el.renderNode != null) {
        multiNode.addChild(el.renderNode!);
      }
    }
  }

  @override
  void unmount() {
    for (final el in _childElements) {
      el.unmount();
    }
    _childElements.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    for (final el in _childElements) {
      visitor(el);
    }
  }
}

class Column extends NativeRenderWidget {
  final List<Widget> children;

  const Column({super.key, this.children = const []});

  @override
  Element createElement() => ColumnElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return ColumnRenderNode();
  }
}

class Flexible extends SingleChildRenderObjectWidget {
  final int flex;

  const Flexible({
    super.key,
    this.flex = 1,
    required Widget super.child,
  });

  @override
  Element createElement() => FlexibleElement(this);
}

class Expanded extends Flexible {
  const Expanded({
    super.key,
    super.flex = 1,
    required super.child,
  });
}

class FlexibleElement extends Element {
  Element? _childElement;

  FlexibleElement(Flexible super.widget);

  @override
  Flexible get widget => super.widget as Flexible;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final childWidget = widget.child;
    if (childWidget != null) {
      _childElement = childWidget.createElement();
      _childElement!.mount(this);
      renderNode = _childElement!.renderNode;
    }
  }

  @override
  void update(Widget newWidget) {
    final newFlexible = newWidget as Flexible;
    final currentChild = _childElement;
    final newChildWidget = newFlexible.child;

    if (currentChild != null && newChildWidget != null) {
      if (Widget.canUpdate(currentChild.widget, newChildWidget)) {
        currentChild.update(newChildWidget);
      } else {
        currentChild.unmount();
        _childElement = newChildWidget.createElement();
        _childElement!.mount(this);
      }
    }
    renderNode = _childElement?.renderNode;
  }

  @override
  void unmount() {
    _childElement?.unmount();
    _childElement = null;
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}

class ColumnRenderNode extends MultiChildNativeRenderNode {
  ColumnRenderNode() : super(widgetType: 'Column');

  @override
  void performLayout(BoxConstraints constraints) {
    double totalHeight = 0.0;
    double maxWidth = 0.0;
    int totalFlex = 0;

    for (final child in children) {
      final flex = child.props['flex'] as int? ?? 0;
      if (flex == 0) {
        child.performLayout(constraints);
        totalHeight += child.size.height;
        if (child.size.width > maxWidth) maxWidth = child.size.width;
      } else {
        totalFlex += flex;
      }
    }

    final double remainingHeight = constraints.maxHeight.isFinite && constraints.maxHeight > totalHeight
        ? constraints.maxHeight - totalHeight
        : 0.0;

    for (final child in children) {
      final flex = child.props['flex'] as int? ?? 0;
      if (flex > 0 && totalFlex > 0) {
        final allocatedH = (remainingHeight * flex) / totalFlex;
        child.performLayout(BoxConstraints(
          minWidth: constraints.minWidth,
          maxWidth: constraints.maxWidth,
          minHeight: allocatedH,
          maxHeight: allocatedH,
        ));
        totalHeight += child.size.height;
        if (child.size.width > maxWidth) maxWidth = child.size.width;
      }
    }

    double currentY = 0.0;
    for (final child in children) {
      child.offset = Offset(0, currentY);
      currentY += child.size.height;
    }

    size = constraints.constrain(Size(maxWidth, currentY));
  }
}

class Positioned extends SingleChildRenderObjectWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;

  const Positioned({
    super.key,
    this.top,
    this.left,
    this.right,
    this.bottom,
    this.width,
    this.height,
    required Widget super.child,
  });

  const Positioned.fill({
    super.key,
    this.top = 0.0,
    this.left = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
    required Widget super.child,
  })  : width = null,
        height = null;

  @override
  Element createElement() => PositionedElement(this);
}

class PositionedElement extends Element {
  Element? _childElement;

  PositionedElement(Positioned super.widget);

  @override
  Positioned get widget => super.widget as Positioned;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final childWidget = widget.child;
    if (childWidget != null) {
      _childElement = childWidget.createElement();
      _childElement!.mount(this);
      renderNode = _childElement!.renderNode;
    }
  }

  @override
  void update(Widget newWidget) {
    final newPositioned = newWidget as Positioned;
    final currentChild = _childElement;
    final newChildWidget = newPositioned.child;

    if (currentChild != null && newChildWidget != null) {
      if (Widget.canUpdate(currentChild.widget, newChildWidget)) {
        currentChild.update(newChildWidget);
      } else {
        currentChild.unmount();
        _childElement = newChildWidget.createElement();
        _childElement!.mount(this);
      }
    }
    renderNode = _childElement?.renderNode;
  }

  @override
  void unmount() {
    _childElement?.unmount();
    _childElement = null;
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}

class Stack extends NativeRenderWidget {
  final List<Widget> children;

  const Stack({super.key, this.children = const []});

  @override
  Element createElement() => StackElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return StackRenderNode();
  }
}

class StackRenderNode extends MultiChildNativeRenderNode {
  StackRenderNode() : super(widgetType: 'Stack');

  @override
  void performLayout(BoxConstraints constraints) {
    double maxWidth = 0.0;
    double maxHeight = 0.0;

    for (final child in children) {
      final double? top = child.props['top'] as double?;
      final double? left = child.props['left'] as double?;
      final double? width = child.props['width'] as double?;
      final double? height = child.props['height'] as double?;

      final childConstraints = BoxConstraints(
        minWidth: width ?? 0.0,
        maxWidth: width ?? (constraints.maxWidth.isFinite ? constraints.maxWidth : double.infinity),
        minHeight: height ?? 0.0,
        maxHeight: height ?? (constraints.maxHeight.isFinite ? constraints.maxHeight : double.infinity),
      );

      child.performLayout(childConstraints);

      final double childRight = (left ?? 0.0) + child.size.width;
      final double childBottom = (top ?? 0.0) + child.size.height;

      if (childRight > maxWidth) maxWidth = childRight;
      if (childBottom > maxHeight) maxHeight = childBottom;
    }

    final double calcW = constraints.minWidth > maxWidth ? constraints.minWidth : maxWidth;
    final double calcH = constraints.minHeight > maxHeight ? constraints.minHeight : maxHeight;
    size = constraints.constrain(Size(calcW, calcH));

    for (int i = 0; i < children.length; i++) {
      final childNode = children[i];
      double dx = 0.0;
      double dy = 0.0;

      final props = childNode.props;
      final double? top = props['top'] as double?;
      final double? left = props['left'] as double?;

      if (left != null) dx = left;
      if (top != null) dy = top;

      childNode.offset = Offset(dx, dy);
    }
  }
}

class StackElement extends NativeRenderElement {
  List<Element> _childElements = [];

  StackElement(Stack super.widget);

  @override
  Stack get widget => super.widget as Stack;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;
    _childElements = widget.children.map((w) {
      final el = w.createElement();
      el.mount(this);
      if (el.renderNode != null) {
        if (w is Positioned) {
          el.renderNode!.props['top'] = w.top;
          el.renderNode!.props['left'] = w.left;
          el.renderNode!.props['right'] = w.right;
          el.renderNode!.props['bottom'] = w.bottom;
        }
        multiNode.addChild(el.renderNode!);
      }
      return el;
    }).toList();
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    final newStack = newWidget as Stack;
    final multiNode = renderNode as MultiChildNativeRenderNode;
    final newChildrenWidgets = newStack.children;

    final List<Element> newChildElements = [];
    multiNode.children.clear();

    final int minLength = _childElements.length < newChildrenWidgets.length
        ? _childElements.length
        : newChildrenWidgets.length;

    for (int i = 0; i < minLength; i++) {
      final oldEl = _childElements[i];
      final newW = newChildrenWidgets[i];
      if (Widget.canUpdate(oldEl.widget, newW)) {
        oldEl.update(newW);
        newChildElements.add(oldEl);
      } else {
        oldEl.unmount();
        final newEl = newW.createElement();
        newEl.mount(this);
        newChildElements.add(newEl);
      }
    }

    if (_childElements.length > newChildrenWidgets.length) {
      for (int i = minLength; i < _childElements.length; i++) {
        _childElements[i].unmount();
      }
    } else if (newChildrenWidgets.length > _childElements.length) {
      for (int i = minLength; i < newChildrenWidgets.length; i++) {
        final newEl = newChildrenWidgets[i].createElement();
        newEl.mount(this);
        newChildElements.add(newEl);
      }
    }

    _childElements = newChildElements;
    for (int i = 0; i < _childElements.length; i++) {
      final el = _childElements[i];
      final w = newChildrenWidgets[i];
      if (el.renderNode != null) {
        if (w is Positioned) {
          el.renderNode!.props['top'] = w.top;
          el.renderNode!.props['left'] = w.left;
          el.renderNode!.props['right'] = w.right;
          el.renderNode!.props['bottom'] = w.bottom;
        }
        multiNode.addChild(el.renderNode!);
      }
    }
  }

  @override
  void unmount() {
    for (final el in _childElements) {
      el.unmount();
    }
    _childElements.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    for (final el in _childElements) {
      visitor(el);
    }
  }
}

class ListView extends NativeRenderWidget {
  final List<Widget> children;
  final double itemExtent;

  const ListView({
    super.key,
    this.children = const [],
    this.itemExtent = 50.0,
  });

  @override
  Element createElement() => ListViewElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return ListViewRenderNode(props: {'itemExtent': itemExtent});
  }
}

class ListViewRenderNode extends MultiChildNativeRenderNode {
  ListViewRenderNode({required super.props}) : super(widgetType: 'ListView');

  @override
  void performLayout(BoxConstraints constraints) {
    final double itemExtent = (props['itemExtent'] as num?)?.toDouble() ?? 50.0;
    double currentY = 0.0;

    for (final child in children) {
      child.performLayout(BoxConstraints(
        minWidth: constraints.minWidth,
        maxWidth: constraints.maxWidth,
        minHeight: itemExtent,
        maxHeight: itemExtent,
      ));
      child.offset = Offset(0, currentY);
      currentY += itemExtent;
    }

    size = constraints.constrain(Size(constraints.maxWidth.isFinite ? constraints.maxWidth : 300.0, currentY));
  }
}

class ListViewElement extends NativeRenderElement {
  List<Element> _childElements = [];

  ListViewElement(ListView super.widget);

  @override
  ListView get widget => super.widget as ListView;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;
    _childElements = widget.children.map((w) {
      final el = w.createElement();
      el.mount(this);
      if (el.renderNode != null) {
        if (w is Flexible) {
          el.renderNode!.props['flex'] = w.flex;
        }
        multiNode.addChild(el.renderNode!);
      }
      return el;
    }).toList();
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    final newListView = newWidget as ListView;
    final multiNode = renderNode as MultiChildNativeRenderNode;
    final newChildrenWidgets = newListView.children;

    final List<Element> newChildElements = [];
    multiNode.children.clear();

    final int minLength = _childElements.length < newChildrenWidgets.length
        ? _childElements.length
        : newChildrenWidgets.length;

    for (int i = 0; i < minLength; i++) {
      final oldEl = _childElements[i];
      final newW = newChildrenWidgets[i];
      if (Widget.canUpdate(oldEl.widget, newW)) {
        oldEl.update(newW);
        newChildElements.add(oldEl);
      } else {
        oldEl.unmount();
        final newEl = newW.createElement();
        newEl.mount(this);
        newChildElements.add(newEl);
      }
    }

    if (_childElements.length > newChildrenWidgets.length) {
      for (int i = minLength; i < _childElements.length; i++) {
        _childElements[i].unmount();
      }
    } else if (newChildrenWidgets.length > _childElements.length) {
      for (int i = minLength; i < newChildrenWidgets.length; i++) {
        final newEl = newChildrenWidgets[i].createElement();
        newEl.mount(this);
        newChildElements.add(newEl);
      }
    }

    _childElements = newChildElements;
    for (final el in _childElements) {
      if (el.renderNode != null) {
        multiNode.addChild(el.renderNode!);
      }
    }
  }

  @override
  void unmount() {
    for (final el in _childElements) {
      el.unmount();
    }
    _childElements.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    for (final el in _childElements) {
      visitor(el);
    }
  }
}

class AndroidNativeView extends NativeRenderWidget {
  final String viewType;
  final Map<String, dynamic> creationParams;

  const AndroidNativeView({
    super.key,
    required this.viewType,
    this.creationParams = const {},
  });

  @override
  NativeRenderNode createRenderNode() {
    return PlatformViewRenderNode(
      widgetType: 'AndroidView',
      props: {
        'viewType': viewType,
        'creationParams': creationParams,
      },
    );
  }
}

class UIKitNativeView extends NativeRenderWidget {
  final String viewType;
  final Map<String, dynamic> creationParams;

  const UIKitNativeView({
    super.key,
    required this.viewType,
    this.creationParams = const {},
  });

  @override
  NativeRenderNode createRenderNode() {
    return PlatformViewRenderNode(
      widgetType: 'UIKitView',
      props: {
        'viewType': viewType,
        'creationParams': creationParams,
      },
    );
  }
}

class PlatformViewRenderNode extends NativeRenderNode {
  PlatformViewRenderNode({required super.widgetType, required super.props});

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(Size(
      constraints.maxWidth.isFinite ? constraints.maxWidth : 300.0,
      constraints.maxHeight.isFinite ? constraints.maxHeight : 200.0,
    ));
  }
}

class Chip extends StatelessWidget {
  final Widget label;
  final Widget? avatar;

  const Chip({
    super.key,
    required this.label,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      backgroundColor: '#E0E0E0',
      child: Padding(
        padding: 6.0,
        child: Row(
          children: [
            if (avatar != null) ...[
              avatar!,
              const SizedBox(width: 4.0),
            ],
            label,
          ],
        ),
      ),
    );
  }
}

class Wrap extends NativeRenderWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;

  const Wrap({
    super.key,
    this.children = const [],
    this.spacing = 8.0,
    this.runSpacing = 8.0,
  });

  @override
  Element createElement() => WrapElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return WrapRenderNode(
      props: {
        'spacing': spacing,
        'runSpacing': runSpacing,
      },
    );
  }
}

class WrapRenderNode extends MultiChildNativeRenderNode {
  WrapRenderNode({required super.props}) : super(widgetType: 'Wrap');

  @override
  void performLayout(BoxConstraints constraints) {
    final double spacing = (props['spacing'] as num?)?.toDouble() ?? 8.0;
    final double runSpacing = (props['runSpacing'] as num?)?.toDouble() ?? 8.0;
    final double maxW = constraints.maxWidth.isFinite ? constraints.maxWidth : 800.0;

    double currentX = 0.0;
    double currentY = 0.0;
    double lineMaxHeight = 0.0;
    double totalWidth = 0.0;

    for (final child in children) {
      child.performLayout(constraints);

      if (currentX + child.size.width > maxW && currentX > 0) {
        currentX = 0.0;
        currentY += lineMaxHeight + runSpacing;
        lineMaxHeight = 0.0;
      }

      child.offset = Offset(currentX, currentY);
      currentX += child.size.width + spacing;
      if (child.size.height > lineMaxHeight) lineMaxHeight = child.size.height;
      if (currentX > totalWidth) totalWidth = currentX;
    }

    size = constraints.constrain(Size(totalWidth, currentY + lineMaxHeight));
  }
}

class WrapElement extends NativeRenderElement {
  List<Element> _childElements = [];

  WrapElement(Wrap super.widget);

  @override
  Wrap get widget => super.widget as Wrap;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;
    _childElements = widget.children.map((w) {
      final el = w.createElement();
      el.mount(this);
      if (el.renderNode != null) {
        multiNode.addChild(el.renderNode!);
      }
      return el;
    }).toList();
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    final newWrap = newWidget as Wrap;
    final multiNode = renderNode as MultiChildNativeRenderNode;
    final newChildrenWidgets = newWrap.children;

    final List<Element> newChildElements = [];
    multiNode.children.clear();

    final int minLength = _childElements.length < newChildrenWidgets.length
        ? _childElements.length
        : newChildrenWidgets.length;

    for (int i = 0; i < minLength; i++) {
      final oldEl = _childElements[i];
      final newW = newChildrenWidgets[i];
      if (Widget.canUpdate(oldEl.widget, newW)) {
        oldEl.update(newW);
        newChildElements.add(oldEl);
      } else {
        oldEl.unmount();
        final newEl = newW.createElement();
        newEl.mount(this);
        newChildElements.add(newEl);
      }
    }

    if (_childElements.length > newChildrenWidgets.length) {
      for (int i = minLength; i < _childElements.length; i++) {
        _childElements[i].unmount();
      }
    } else if (newChildrenWidgets.length > _childElements.length) {
      for (int i = minLength; i < newChildrenWidgets.length; i++) {
        final newEl = newChildrenWidgets[i].createElement();
        newEl.mount(this);
        newChildElements.add(newEl);
      }
    }

    _childElements = newChildElements;
    for (final el in _childElements) {
      if (el.renderNode != null) {
        multiNode.addChild(el.renderNode!);
      }
    }
  }

  @override
  void unmount() {
    for (final el in _childElements) {
      el.unmount();
    }
    _childElements.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    for (final el in _childElements) {
      visitor(el);
    }
  }
}

class ColumnElement extends NativeRenderElement {
  List<Element> _childElements = [];

  ColumnElement(Column super.widget);

  @override
  Column get widget => super.widget as Column;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;
    _childElements = widget.children.map((w) {
      final el = w.createElement();
      el.mount(this);
      if (el.renderNode != null) {
        multiNode.addChild(el.renderNode!);
      }
      return el;
    }).toList();
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    final newColumn = newWidget as Column;
    final multiNode = renderNode as MultiChildNativeRenderNode;
    final newChildrenWidgets = newColumn.children;

    final List<Element> newChildElements = [];
    multiNode.children.clear();

    final int minLength = _childElements.length < newChildrenWidgets.length
        ? _childElements.length
        : newChildrenWidgets.length;

    for (int i = 0; i < minLength; i++) {
      final oldEl = _childElements[i];
      final newW = newChildrenWidgets[i];
      if (Widget.canUpdate(oldEl.widget, newW)) {
        oldEl.update(newW);
        newChildElements.add(oldEl);
      } else {
        oldEl.unmount();
        final newEl = newW.createElement();
        newEl.mount(this);
        newChildElements.add(newEl);
      }
    }

    if (_childElements.length > newChildrenWidgets.length) {
      for (int i = minLength; i < _childElements.length; i++) {
        _childElements[i].unmount();
      }
    } else if (newChildrenWidgets.length > _childElements.length) {
      for (int i = minLength; i < newChildrenWidgets.length; i++) {
        final newEl = newChildrenWidgets[i].createElement();
        newEl.mount(this);
        newChildElements.add(newEl);
      }
    }

    _childElements = newChildElements;
    for (final el in _childElements) {
      if (el.renderNode != null) {
        multiNode.addChild(el.renderNode!);
      }
    }
  }

  @override
  void unmount() {
    for (final el in _childElements) {
      el.unmount();
    }
    _childElements.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    for (final el in _childElements) {
      visitor(el);
    }
  }
}
