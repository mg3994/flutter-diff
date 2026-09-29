import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class CupertinoTimerPicker extends NativeRenderWidget {
  final Duration initialTimerDuration;
  final void Function(Duration newDuration)? onTimerDurationChanged;

  const CupertinoTimerPicker({
    super.key,
    this.initialTimerDuration = Duration.zero,
    required this.onTimerDurationChanged,
  });

  @override
  Element createElement() => CupertinoTimerPickerElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return CupertinoTimerPickerRenderNode(
      props: {'initialDurationMs': initialTimerDuration.inMilliseconds},
    );
  }
}

class CupertinoTimerPickerRenderNode extends NativeRenderNode {
  CupertinoTimerPickerRenderNode({required super.props})
      : super(widgetType: 'CupertinoTimerPicker');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(Size(
      constraints.maxWidth.isFinite ? constraints.maxWidth : 300.0,
      216.0,
    ));
  }
}

class CupertinoTimerPickerElement extends NativeRenderElement {
  CupertinoTimerPickerElement(CupertinoTimerPicker super.widget);

  @override
  CupertinoTimerPicker get widget => super.widget as CupertinoTimerPicker;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    renderNode?.onNativeHandleCreated = (handle) {
      _registerEvents(handle);
    };
    if (renderNode?.nativeHandle != null) {
      _registerEvents(renderNode!.nativeHandle!);
    }
  }

  void _registerEvents(int handle) {
    final backend = appOwner?.backend;
    if (backend != null && widget.onTimerDurationChanged != null) {
      backend.registerEventListener(handle, 'durationChange', (name, data) {
        final ms = (data['durationMs'] as num?)?.toInt() ?? 0;
        widget.onTimerDurationChanged?.call(Duration(milliseconds: ms));
      });
    }
  }
}

class CupertinoSearchTextField extends NativeRenderWidget {
  final String? placeholder;
  final void Function(String text)? onChanged;
  final void Function(String text)? onSubmitted;

  const CupertinoSearchTextField({
    super.key,
    this.placeholder,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Element createElement() => CupertinoSearchTextFieldElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return CupertinoSearchTextFieldRenderNode(
      props: {if (placeholder != null) 'placeholder': placeholder},
    );
  }
}

class CupertinoSearchTextFieldRenderNode extends NativeRenderNode {
  CupertinoSearchTextFieldRenderNode({required super.props})
      : super(widgetType: 'CupertinoSearchTextField');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(Size(
      constraints.maxWidth.isFinite ? constraints.maxWidth : 300.0,
      36.0,
    ));
  }
}

class CupertinoSearchTextFieldElement extends NativeRenderElement {
  CupertinoSearchTextFieldElement(CupertinoSearchTextField super.widget);

  @override
  CupertinoSearchTextField get widget => super.widget as CupertinoSearchTextField;

  @override
  void mount(Element? parent) {
    super.mount(parent);
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
      if (widget.onChanged != null) {
        backend.registerEventListener(handle, 'change', (name, data) {
          final query = (data['text'] as String?) ?? '';
          widget.onChanged?.call(query);
        });
      }
      if (widget.onSubmitted != null) {
        backend.registerEventListener(handle, 'submit', (name, data) {
          final query = (data['text'] as String?) ?? '';
          widget.onSubmitted?.call(query);
        });
      }
    }
  }
}

class CupertinoSlidingSegmentedControl<T extends Object> extends NativeRenderWidget {
  final T? groupValue;
  final Map<T, Widget> children;
  final void Function(T? value)? onValueChanged;

  const CupertinoSlidingSegmentedControl({
    super.key,
    required this.groupValue,
    required this.children,
    required this.onValueChanged,
  });

  @override
  Element createElement() => CupertinoSlidingSegmentedControlElement<T>(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'CupertinoSlidingSegmentedControl',
      props: {'groupValue': groupValue?.toString()},
    );
  }
}

class CupertinoSlidingSegmentedControlElement<T extends Object> extends NativeRenderElement {
  List<Element> _childElements = [];

  CupertinoSlidingSegmentedControlElement(CupertinoSlidingSegmentedControl<T> super.widget);

  @override
  CupertinoSlidingSegmentedControl<T> get widget => super.widget as CupertinoSlidingSegmentedControl<T>;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    _childElements = widget.children.values.map((w) {
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
      return el;
    }).toList();

    renderNode?.onNativeHandleCreated = (handle) {
      _registerEvents(handle);
    };
    if (renderNode?.nativeHandle != null) {
      _registerEvents(renderNode!.nativeHandle!);
    }
  }

  void _registerEvents(int handle) {
    final backend = appOwner?.backend;
    if (backend != null && widget.onValueChanged != null) {
      backend.registerEventListener(handle, 'select', (name, data) {
        final index = (data['index'] as num?)?.toInt() ?? 0;
        final keys = widget.children.keys.toList();
        if (index >= 0 && index < keys.length) {
          widget.onValueChanged?.call(keys[index]);
        }
      });
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
