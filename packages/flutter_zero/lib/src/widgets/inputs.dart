import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class Checkbox extends NativeRenderWidget {
  final bool value;
  final void Function(bool? newValue)? onChanged;

  const Checkbox({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Element createElement() => CheckboxElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'Checkbox',
      props: {'value': value, 'enabled': onChanged != null},
    );
  }
}

class CheckboxElement extends NativeRenderElement {
  CheckboxElement(Checkbox super.widget);

  @override
  Checkbox get widget => super.widget as Checkbox;

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
      backend.registerEventListener(handle, 'change', (eventName, data) {
        final newVal = data['value'] as bool? ?? false;
        widget.onChanged?.call(newVal);
      });
    }
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    if (renderNode?.nativeHandle != null) {
      _registerEvents(renderNode!.nativeHandle!);
    }
  }
}

class Switch extends NativeRenderWidget {
  final bool value;
  final void Function(bool newValue)? onChanged;

  const Switch({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Element createElement() => SwitchElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'Switch',
      props: {'value': value, 'enabled': onChanged != null},
    );
  }
}

class SwitchElement extends NativeRenderElement {
  SwitchElement(Switch super.widget);

  @override
  Switch get widget => super.widget as Switch;

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
      backend.registerEventListener(handle, 'change', (eventName, data) {
        final newVal = data['value'] as bool? ?? false;
        widget.onChanged?.call(newVal);
      });
    }
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    if (renderNode?.nativeHandle != null) {
      _registerEvents(renderNode!.nativeHandle!);
    }
  }
}

class Slider extends NativeRenderWidget {
  final double value;
  final double min;
  final double max;
  final void Function(double newValue)? onChanged;

  const Slider({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    this.onChanged,
  });

  @override
  Element createElement() => SliderElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'Slider',
      props: {'value': value, 'min': min, 'max': max, 'enabled': onChanged != null},
    );
  }
}

class SliderElement extends NativeRenderElement {
  SliderElement(Slider super.widget);

  @override
  Slider get widget => super.widget as Slider;

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
      backend.registerEventListener(handle, 'change', (eventName, data) {
        final newVal = (data['value'] as num?)?.toDouble() ?? 0.0;
        widget.onChanged?.call(newVal);
      });
    }
  }

  @override
  void update(Widget newWidget) {
    super.update(newWidget);
    if (renderNode?.nativeHandle != null) {
      _registerEvents(renderNode!.nativeHandle!);
    }
  }
}
