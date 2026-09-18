import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class InputChip extends NativeRenderWidget {
  final Widget label;
  final Widget? avatar;
  final void Function()? onPressed;
  final void Function()? onDeleted;

  const InputChip({
    super.key,
    required this.label,
    this.avatar,
    this.onPressed,
    this.onDeleted,
  });

  @override
  Element createElement() => InputChipElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'InputChip',
      props: {
        'enabled': onPressed != null,
        'deletable': onDeleted != null,
      },
    );
  }
}

class InputChipElement extends NativeRenderElement {
  Element? _avatarEl;
  Element? _labelEl;

  InputChipElement(InputChip super.widget);

  @override
  InputChip get widget => super.widget as InputChip;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    if (widget.avatar != null) {
      _avatarEl = widget.avatar!.createElement()..mount(this);
      if (_avatarEl?.renderNode != null) multiNode.addChild(_avatarEl!.renderNode!);
    }

    _labelEl = widget.label.createElement()..mount(this);
    if (_labelEl?.renderNode != null) multiNode.addChild(_labelEl!.renderNode!);

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
      if (widget.onPressed != null) {
        backend.registerEventListener(handle, 'click', (name, data) => widget.onPressed?.call());
      }
      if (widget.onDeleted != null) {
        backend.registerEventListener(handle, 'delete', (name, data) => widget.onDeleted?.call());
      }
    }
  }

  @override
  void unmount() {
    _avatarEl?.unmount();
    _labelEl?.unmount();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_avatarEl != null) visitor(_avatarEl!);
    if (_labelEl != null) visitor(_labelEl!);
  }
}

class RawChip extends NativeRenderWidget {
  final Widget label;
  final Widget? avatar;
  final bool selected;
  final void Function(bool selected)? onSelected;

  const RawChip({
    super.key,
    required this.label,
    this.avatar,
    this.selected = false,
    this.onSelected,
  });

  @override
  Element createElement() => RawChipElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'RawChip',
      props: {'selected': selected},
    );
  }
}

class RawChipElement extends NativeRenderElement {
  Element? _avatarEl;
  Element? _labelEl;

  RawChipElement(RawChip super.widget);

  @override
  RawChip get widget => super.widget as RawChip;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    if (widget.avatar != null) {
      _avatarEl = widget.avatar!.createElement()..mount(this);
      if (_avatarEl?.renderNode != null) multiNode.addChild(_avatarEl!.renderNode!);
    }

    _labelEl = widget.label.createElement()..mount(this);
    if (_labelEl?.renderNode != null) multiNode.addChild(_labelEl!.renderNode!);

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
  void unmount() {
    _avatarEl?.unmount();
    _labelEl?.unmount();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_avatarEl != null) visitor(_avatarEl!);
    if (_labelEl != null) visitor(_labelEl!);
  }
}
