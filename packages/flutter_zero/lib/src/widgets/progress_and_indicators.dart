import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class CircularProgressIndicator extends NativeRenderWidget {
  final double? value;
  final String? color;

  const CircularProgressIndicator({
    super.key,
    this.value,
    this.color,
  });

  @override
  NativeRenderNode createRenderNode() {
    return CircularProgressRenderNode(
      props: {
        if (value != null) 'value': value,
        if (color != null) 'color': color,
      },
    );
  }
}

class CircularProgressRenderNode extends NativeRenderNode {
  CircularProgressRenderNode({required super.props})
      : super(widgetType: 'CircularProgressIndicator');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(const Size(36.0, 36.0));
  }
}

class LinearProgressIndicator extends NativeRenderWidget {
  final double? value;
  final String? color;

  const LinearProgressIndicator({
    super.key,
    this.value,
    this.color,
  });

  @override
  NativeRenderNode createRenderNode() {
    return LinearProgressRenderNode(
      props: {
        if (value != null) 'value': value,
        if (color != null) 'color': color,
      },
    );
  }
}

class LinearProgressRenderNode extends NativeRenderNode {
  LinearProgressRenderNode({required super.props})
      : super(widgetType: 'LinearProgressIndicator');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(Size(
      constraints.maxWidth.isFinite ? constraints.maxWidth : 200.0,
      4.0,
    ));
  }
}

class RefreshIndicator extends NativeRenderWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const RefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Element createElement() => RefreshIndicatorElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(widgetType: 'RefreshIndicator');
  }
}

class RefreshIndicatorElement extends NativeRenderElement {
  Element? _childElement;

  RefreshIndicatorElement(RefreshIndicator super.widget);

  @override
  RefreshIndicator get widget => super.widget as RefreshIndicator;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _childElement = widget.child.createElement();
    _childElement!.mount(this);
    if (_childElement!.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _childElement!.renderNode;
    }

    renderNode?.onNativeHandleCreated = (handle) {
      _registerEvents(handle);
    };
    if (renderNode?.nativeHandle != null) {
      _registerEvents(renderNode!.nativeHandle!);
    }
  }

  void _registerEvents(int handle) {
    final backend = appOwner?.backend;
    if (backend != null) {
      backend.registerEventListener(handle, 'refresh', (eventName, data) async {
        await widget.onRefresh();
      });
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}

class Step {
  final Widget title;
  final Widget? content;
  final bool isActive;

  const Step({
    required this.title,
    this.content,
    this.isActive = false,
  });
}

class Stepper extends NativeRenderWidget {
  final List<Step> steps;
  final int currentStep;
  final void Function(int step)? onStepTapped;

  const Stepper({
    super.key,
    required this.steps,
    this.currentStep = 0,
    this.onStepTapped,
  });

  @override
  Element createElement() => StepperElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'Stepper',
      props: {'currentStep': currentStep},
    );
  }
}

class StepperElement extends NativeRenderElement {
  List<Element> _stepChildElements = [];

  StepperElement(Stepper super.widget);

  @override
  Stepper get widget => super.widget as Stepper;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    for (final step in widget.steps) {
      final titleEl = step.title.createElement()..mount(this);
      if (titleEl.renderNode != null) multiNode.addChild(titleEl.renderNode!);
      _stepChildElements.add(titleEl);

      if (step.content != null) {
        final contentEl = step.content!.createElement()..mount(this);
        if (contentEl.renderNode != null) multiNode.addChild(contentEl.renderNode!);
        _stepChildElements.add(contentEl);
      }
    }

    renderNode?.onNativeHandleCreated = (handle) {
      _registerEvents(handle);
    };
    if (renderNode?.nativeHandle != null) {
      _registerEvents(renderNode!.nativeHandle!);
    }
  }

  void _registerEvents(int handle) {
    final backend = appOwner?.backend;
    if (backend != null && widget.onStepTapped != null) {
      backend.registerEventListener(handle, 'stepTap', (eventName, data) {
        final step = (data['step'] as num?)?.toInt() ?? 0;
        widget.onStepTapped?.call(step);
      });
    }
  }

  @override
  void unmount() {
    for (final el in _stepChildElements) {
      el.unmount();
    }
    _stepChildElements.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    for (final el in _stepChildElements) {
      visitor(el);
    }
  }
}
