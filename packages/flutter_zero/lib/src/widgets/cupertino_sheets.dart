import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class CupertinoActionSheetAction extends NativeRenderWidget {
  final Widget child;
  final void Function() onPressed;
  final bool isDefaultAction;
  final bool isDestructiveAction;

  const CupertinoActionSheetAction({
    super.key,
    required this.child,
    required this.onPressed,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
  });

  @override
  Element createElement() => CupertinoActionSheetActionElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'CupertinoActionSheetAction',
      props: {
        'isDefaultAction': isDefaultAction,
        'isDestructiveAction': isDestructiveAction,
      },
    );
  }
}

class CupertinoActionSheetActionElement extends NativeRenderElement {
  Element? _childElement;

  CupertinoActionSheetActionElement(CupertinoActionSheetAction super.widget);

  @override
  CupertinoActionSheetAction get widget => super.widget as CupertinoActionSheetAction;

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
      backend.registerEventListener(handle, 'click', (name, data) {
        widget.onPressed();
      });
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}

class CupertinoActionSheet extends NativeRenderWidget {
  final Widget? title;
  final Widget? message;
  final List<Widget> actions;
  final Widget? cancelButton;

  const CupertinoActionSheet({
    super.key,
    this.title,
    this.message,
    this.actions = const [],
    this.cancelButton,
  });

  @override
  Element createElement() => CupertinoActionSheetElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'CupertinoActionSheet');
  }
}

class CupertinoActionSheetElement extends NativeRenderElement {
  Element? _titleEl;
  Element? _messageEl;
  Element? _cancelEl;
  List<Element> _actionEls = [];

  CupertinoActionSheetElement(CupertinoActionSheet super.widget);

  @override
  CupertinoActionSheet get widget => super.widget as CupertinoActionSheet;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    if (widget.title != null) {
      _titleEl = widget.title!.createElement()..mount(this);
      if (_titleEl?.renderNode != null) multiNode.addChild(_titleEl!.renderNode!);
    }
    if (widget.message != null) {
      _messageEl = widget.message!.createElement()..mount(this);
      if (_messageEl?.renderNode != null) multiNode.addChild(_messageEl!.renderNode!);
    }

    _actionEls = widget.actions.map((w) {
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
      return el;
    }).toList();

    if (widget.cancelButton != null) {
      _cancelEl = widget.cancelButton!.createElement()..mount(this);
      if (_cancelEl?.renderNode != null) multiNode.addChild(_cancelEl!.renderNode!);
    }
  }

  @override
  void unmount() {
    _titleEl?.unmount();
    _messageEl?.unmount();
    _cancelEl?.unmount();
    for (final el in _actionEls) {
      el.unmount();
    }
    _actionEls.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_titleEl != null) visitor(_titleEl!);
    if (_messageEl != null) visitor(_messageEl!);
    for (final el in _actionEls) {
      visitor(el);
    }
    if (_cancelEl != null) visitor(_cancelEl!);
  }
}
