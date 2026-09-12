import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';

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
  NativeRenderNode createRenderNode() {
    return TextRenderNode(
      props: {
        'text': text,
        if (fontSize != null) 'fontSize': fontSize,
        if (color != null) 'color': color,
      },
    );
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
  NativeRenderNode createRenderNode() {
    return TextFieldRenderNode(
      props: {
        if (placeholder != null) 'placeholder': placeholder,
        if (initialValue != null) 'value': initialValue,
      },
    );
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

class ColumnRenderNode extends MultiChildNativeRenderNode {
  ColumnRenderNode() : super(widgetType: 'Column');
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
