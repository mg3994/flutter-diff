import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class SnackBarAction extends NativeRenderWidget {
  final String label;
  final void Function() onPressed;

  const SnackBarAction({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Element createElement() => SnackBarActionElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'SnackBarAction',
      props: {'label': label},
    );
  }
}

class SnackBarActionElement extends NativeRenderElement {
  SnackBarActionElement(SnackBarAction super.widget);

  @override
  SnackBarAction get widget => super.widget as SnackBarAction;

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
      backend.registerEventListener(handle, 'click', (name, data) {
        widget.onPressed();
      });
    }
  }
}

class SnackBar extends NativeRenderWidget {
  final Widget content;
  final SnackBarAction? action;
  final Duration duration;

  const SnackBar({
    super.key,
    required this.content,
    this.action,
    this.duration = const Duration(milliseconds: 4000),
  });

  @override
  Element createElement() => SnackBarElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'SnackBar',
      props: {'durationMs': duration.inMilliseconds},
    );
  }
}

class SnackBarElement extends NativeRenderElement {
  Element? _contentEl;
  Element? _actionEl;

  SnackBarElement(SnackBar super.widget);

  @override
  SnackBar get widget => super.widget as SnackBar;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    _contentEl = widget.content.createElement()..mount(this);
    if (_contentEl?.renderNode != null) multiNode.addChild(_contentEl!.renderNode!);

    if (widget.action != null) {
      _actionEl = widget.action!.createElement()..mount(this);
      if (_actionEl?.renderNode != null) multiNode.addChild(_actionEl!.renderNode!);
    }
  }

  @override
  void unmount() {
    _contentEl?.unmount();
    _actionEl?.unmount();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_contentEl != null) visitor(_contentEl!);
    if (_actionEl != null) visitor(_actionEl!);
  }
}
