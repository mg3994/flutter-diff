import 'render_node.dart';
import 'widget.dart';

abstract class BuildContext {
  Widget get widget;
  bool get mounted;
}

abstract class Element implements BuildContext {
  Widget _widget;
  @override
  Widget get widget => _widget;

  Element? parent;
  NativeRenderNode? renderNode;

  Element(this._widget);

  @override
  bool get mounted => parent != null || _isRoot;
  bool _isRoot = false;

  void mount(Element? parent) {
    this.parent = parent;
  }

  void update(Widget newWidget);

  void unmount() {
    parent = null;
    renderNode = null;
  }

  void rebuild() {}

  void visitChildren(void Function(Element element) visitor);
}

abstract class ComponentElement extends Element {
  Element? _child;

  ComponentElement(super.widget);

  @override
  void mount(Element? parent) {
    super.mount(parent);
    rebuild();
  }

  @override
  void rebuild() {
    final Widget built = build();
    if (_child == null) {
      _child = built.createElement();
      _child!.mount(this);
    } else if (Widget.canUpdate(_child!.widget, built)) {
      _child!.update(built);
    } else {
      _child!.unmount();
      _child = built.createElement();
      _child!.mount(this);
    }
    renderNode = _child!.renderNode;
  }

  @override
  void update(Widget newWidget) {
    _widget = newWidget;
    rebuild();
  }

  @override
  void unmount() {
    _child?.unmount();
    _child = null;
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_child != null) visitor(_child!);
  }

  Widget build();
}

class StatelessElement extends ComponentElement {
  StatelessElement(StatelessWidget super.widget);

  @override
  StatelessWidget get widget => super.widget as StatelessWidget;

  @override
  Widget build() => widget.build(this);
}

class StatefulElement extends ComponentElement {
  late final State<StatefulWidget> _state;

  StatefulElement(StatefulWidget super.widget) {
    _state = widget.createState();
    _state.attachElement(this, widget);
  }

  @override
  StatefulWidget get widget => super.widget as StatefulWidget;

  State<StatefulWidget> get state => _state;

  @override
  void mount(Element? parent) {
    _state.initState();
    super.mount(parent);
  }

  @override
  void update(Widget newWidget) {
    final StatefulWidget oldWidget = widget;
    _state.updateWidget(newWidget as StatefulWidget);
    _state.didUpdateWidget(oldWidget);
    rebuild();
  }

  void markNeedsBuild() {
    rebuild();
  }

  @override
  void unmount() {
    _state.dispose();
    _state.detachElement();
    super.unmount();
  }

  @override
  Widget build() => _state.build(this);
}

class RootElement extends Element {
  Element? _child;

  RootElement(Widget rootWidget) : super(rootWidget) {
    _isRoot = true;
  }

  void mountRoot() {
    mount(null);
    _child = widget.createElement();
    _child!.mount(this);
    renderNode = _child!.renderNode;
  }

  void updateRoot(Widget newWidget) {
    if (Widget.canUpdate(_child!.widget, newWidget)) {
      _child!.update(newWidget);
    } else {
      _child!.unmount();
      _child = newWidget.createElement();
      _child!.mount(this);
    }
    renderNode = _child!.renderNode;
  }

  @override
  void update(Widget newWidget) => updateRoot(newWidget);

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_child != null) visitor(_child!);
  }
}
