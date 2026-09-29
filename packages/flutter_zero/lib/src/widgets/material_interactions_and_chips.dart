import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class InkWell extends NativeRenderWidget {
  final Widget child;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;

  const InkWell({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  });

  @override
  Element createElement() => InkWellElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(widgetType: 'InkWell');
  }
}

class InkWellElement extends NativeRenderElement {
  Element? _childElement;

  InkWellElement(InkWell super.widget);

  @override
  InkWell get widget => super.widget as InkWell;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _childElement = widget.child.createElement()..mount(this);
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
      if (widget.onTap != null) {
        backend.registerEventListener(handle, 'tap', (name, data) => widget.onTap?.call());
      }
      if (widget.onDoubleTap != null) {
        backend.registerEventListener(handle, 'doubleTap', (name, data) => widget.onDoubleTap?.call());
      }
      if (widget.onLongPress != null) {
        backend.registerEventListener(handle, 'longPress', (name, data) => widget.onLongPress?.call());
      }
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}

class Material extends NativeRenderWidget {
  final Widget? child;
  final double elevation;
  final String? color;

  const Material({
    super.key,
    this.child,
    this.elevation = 0.0,
    this.color,
  });

  @override
  Element createElement() => MaterialElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'Material',
      props: {
        'elevation': elevation,
        if (color != null) 'color': color,
      },
    );
  }
}

class MaterialElement extends NativeRenderElement {
  Element? _childElement;

  MaterialElement(Material super.widget);

  @override
  Material get widget => super.widget as Material;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    if (widget.child != null) {
      _childElement = widget.child!.createElement()..mount(this);
      if (_childElement!.renderNode != null) {
        (renderNode as SingleChildNativeRenderNode).child = _childElement!.renderNode;
      }
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}

class FilterChip extends NativeRenderWidget {
  final Widget label;
  final bool selected;
  final void Function(bool selected)? onSelected;

  const FilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
  });

  @override
  Element createElement() => FilterChipElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'FilterChip',
      props: {'selected': selected},
    );
  }
}

class FilterChipElement extends NativeRenderElement {
  Element? _labelEl;

  FilterChipElement(FilterChip super.widget);

  @override
  FilterChip get widget => super.widget as FilterChip;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _labelEl = widget.label.createElement()..mount(this);
    if (_labelEl!.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _labelEl!.renderNode;
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
    if (backend != null && widget.onSelected != null) {
      backend.registerEventListener(handle, 'select', (name, data) {
        widget.onSelected?.call(!widget.selected);
      });
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_labelEl != null) visitor(_labelEl!);
  }
}

class ActionChip extends NativeRenderWidget {
  final Widget label;
  final void Function()? onPressed;

  const ActionChip({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Element createElement() => ActionChipElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'ActionChip',
      props: {'enabled': onPressed != null},
    );
  }
}

class ActionChipElement extends NativeRenderElement {
  Element? _labelEl;

  ActionChipElement(ActionChip super.widget);

  @override
  ActionChip get widget => super.widget as ActionChip;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _labelEl = widget.label.createElement()..mount(this);
    if (_labelEl!.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _labelEl!.renderNode;
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
    if (backend != null && widget.onPressed != null) {
      backend.registerEventListener(handle, 'click', (name, data) {
        widget.onPressed?.call();
      });
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_labelEl != null) visitor(_labelEl!);
  }
}

class RangeValues {
  final double start;
  final double end;

  const RangeValues(this.start, this.end);
}

class RangeSlider extends NativeRenderWidget {
  final RangeValues values;
  final double min;
  final double max;
  final void Function(RangeValues values)? onChanged;

  const RangeSlider({
    super.key,
    required this.values,
    this.min = 0.0,
    this.max = 1.0,
    this.onChanged,
  });

  @override
  Element createElement() => RangeSliderElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return RangeSliderRenderNode(
      props: {
        'start': values.start,
        'end': values.end,
        'min': min,
        'max': max,
      },
    );
  }
}

class RangeSliderRenderNode extends NativeRenderNode {
  RangeSliderRenderNode({required super.props}) : super(widgetType: 'RangeSlider');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(Size(
      constraints.maxWidth.isFinite ? constraints.maxWidth : 200.0,
      48.0,
    ));
  }
}

class RangeSliderElement extends NativeRenderElement {
  RangeSliderElement(RangeSlider super.widget);

  @override
  RangeSlider get widget => super.widget as RangeSlider;

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
    if (backend != null && widget.onChanged != null) {
      backend.registerEventListener(handle, 'change', (name, data) {
        final start = (data['start'] as num?)?.toDouble() ?? widget.values.start;
        final end = (data['end'] as num?)?.toDouble() ?? widget.values.end;
        widget.onChanged?.call(RangeValues(start, end));
      });
    }
  }
}

class Autocomplete<T extends Object> extends NativeRenderWidget {
  final List<T> options;
  final void Function(T selection)? onSelected;

  const Autocomplete({
    super.key,
    required this.options,
    this.onSelected,
  });

  @override
  Element createElement() => AutocompleteElement<T>(this);

  @override
  NativeRenderNode createRenderNode() {
    return AutocompleteRenderNode(
      props: {'optionsCount': options.length},
    );
  }
}

class AutocompleteRenderNode extends NativeRenderNode {
  AutocompleteRenderNode({required super.props}) : super(widgetType: 'Autocomplete');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(Size(
      constraints.maxWidth.isFinite ? constraints.maxWidth : 250.0,
      48.0,
    ));
  }
}

class AutocompleteElement<T extends Object> extends NativeRenderElement {
  AutocompleteElement(Autocomplete<T> super.widget);

  @override
  Autocomplete<T> get widget => super.widget as Autocomplete<T>;

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
    if (backend != null && widget.onSelected != null) {
      backend.registerEventListener(handle, 'select', (name, data) {
        final index = (data['index'] as num?)?.toInt() ?? 0;
        if (index >= 0 && index < widget.options.length) {
          widget.onSelected?.call(widget.options[index]);
        }
      });
    }
  }
}
