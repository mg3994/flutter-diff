import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class SwitchListTile extends NativeRenderWidget {
  final bool value;
  final void Function(bool value)? onChanged;
  final Widget? title;
  final Widget? subtitle;

  const SwitchListTile({
    super.key,
    required this.value,
    required this.onChanged,
    this.title,
    this.subtitle,
  });

  @override
  Element createElement() => SwitchListTileElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'SwitchListTile',
      props: {'value': value},
    );
  }
}

class SwitchListTileElement extends NativeRenderElement {
  Element? _titleEl;
  Element? _subtitleEl;

  SwitchListTileElement(SwitchListTile super.widget);

  @override
  SwitchListTile get widget => super.widget as SwitchListTile;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    if (widget.title != null) {
      _titleEl = widget.title!.createElement()..mount(this);
      if (_titleEl?.renderNode != null) multiNode.addChild(_titleEl!.renderNode!);
    }
    if (widget.subtitle != null) {
      _subtitleEl = widget.subtitle!.createElement()..mount(this);
      if (_subtitleEl?.renderNode != null) multiNode.addChild(_subtitleEl!.renderNode!);
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
    if (backend != null && widget.onChanged != null) {
      backend.registerEventListener(handle, 'toggle', (eventName, data) {
        final newVal = (data['value'] as bool?) ?? !widget.value;
        widget.onChanged?.call(newVal);
      });
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_titleEl != null) visitor(_titleEl!);
    if (_subtitleEl != null) visitor(_subtitleEl!);
  }
}

class RadioListTile<T> extends NativeRenderWidget {
  final T value;
  final T? groupValue;
  final void Function(T? value)? onChanged;
  final Widget? title;
  final Widget? subtitle;

  const RadioListTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.title,
    this.subtitle,
  });

  @override
  Element createElement() => RadioListTileElement<T>(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'RadioListTile',
      props: {'selected': value == groupValue},
    );
  }
}

class RadioListTileElement<T> extends NativeRenderElement {
  Element? _titleEl;
  Element? _subtitleEl;

  RadioListTileElement(RadioListTile<T> super.widget);

  @override
  RadioListTile<T> get widget => super.widget as RadioListTile<T>;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    if (widget.title != null) {
      _titleEl = widget.title!.createElement()..mount(this);
      if (_titleEl?.renderNode != null) multiNode.addChild(_titleEl!.renderNode!);
    }
    if (widget.subtitle != null) {
      _subtitleEl = widget.subtitle!.createElement()..mount(this);
      if (_subtitleEl?.renderNode != null) multiNode.addChild(_subtitleEl!.renderNode!);
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
    if (backend != null && widget.onChanged != null) {
      backend.registerEventListener(handle, 'click', (eventName, data) {
        widget.onChanged?.call(widget.value);
      });
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_titleEl != null) visitor(_titleEl!);
    if (_subtitleEl != null) visitor(_subtitleEl!);
  }
}

class ChoiceChip extends NativeRenderWidget {
  final Widget label;
  final bool selected;
  final void Function(bool selected)? onSelected;

  const ChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
  });

  @override
  Element createElement() => ChoiceChipElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'ChoiceChip',
      props: {'selected': selected},
    );
  }
}

class ChoiceChipElement extends NativeRenderElement {
  Element? _labelEl;

  ChoiceChipElement(ChoiceChip super.widget);

  @override
  ChoiceChip get widget => super.widget as ChoiceChip;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _labelEl = widget.label.createElement();
    _labelEl!.mount(this);
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
      backend.registerEventListener(handle, 'select', (eventName, data) {
        widget.onSelected?.call(!widget.selected);
      });
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_labelEl != null) visitor(_labelEl!);
  }
}
