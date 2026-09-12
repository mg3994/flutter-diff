import '../runner/app_runner.dart';
import 'render_node.dart';
import 'widget.dart';

abstract class BuildContext {
  Widget get widget;
  bool get mounted;
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>();
}

abstract class Element implements BuildContext {
  Widget _widget;
  @override
  Widget get widget => _widget;

  Element? parent;
  NativeRenderNode? renderNode;
  FlutterZeroApp? owner;
  Map<Type, InheritedElement>? _inheritedElements;

  Element(this._widget);

  FlutterZeroApp? get appOwner => owner ?? parent?.appOwner;

  @override
  bool get mounted => parent != null || _isRoot;
  bool _isRoot = false;

  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>() {
    final ancestor = _inheritedElements?[T];
    if (ancestor != null) {
      ancestor._dependents.add(this);
      return ancestor.widget as T;
    }
    return null;
  }

  void mount(Element? parent) {
    this.parent = parent;
    _inheritedElements = parent?._inheritedElements;
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
    performBuild();
  }

  void performBuild() {
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

class InheritedElement extends ComponentElement {
  final Set<Element> _dependents = {};

  InheritedElement(InheritedWidget super.widget);

  @override
  InheritedWidget get widget => super.widget as InheritedWidget;

  @override
  void mount(Element? parent) {
    this.parent = parent;
    final Map<Type, InheritedElement> inherited = Map.from(parent?._inheritedElements ?? {});
    inherited[widget.runtimeType] = this;
    _inheritedElements = inherited;
    performBuild();
  }

  @override
  void update(Widget newWidget) {
    final oldWidget = widget;
    super.update(newWidget);
    if (widget.updateShouldNotify(oldWidget)) {
      for (final dependent in _dependents) {
        dependent.rebuild();
      }
    }
  }

  @override
  Widget build() => widget.child;
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
    this.parent = parent;
    _inheritedElements = parent?._inheritedElements;
    _state.initState();
    performBuild();
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
    appOwner?.scheduleFrame();
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
