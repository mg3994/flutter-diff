import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class CupertinoAlertDialog extends NativeRenderWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget> actions;

  const CupertinoAlertDialog({
    super.key,
    this.title,
    this.content,
    this.actions = const [],
  });

  @override
  Element createElement() => CupertinoAlertDialogElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'CupertinoAlertDialog');
  }
}

class CupertinoAlertDialogElement extends NativeRenderElement {
  Element? _titleEl;
  Element? _contentEl;
  List<Element> _actionEls = [];

  CupertinoAlertDialogElement(CupertinoAlertDialog super.widget);

  @override
  CupertinoAlertDialog get widget => super.widget as CupertinoAlertDialog;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    if (widget.title != null) {
      _titleEl = widget.title!.createElement()..mount(this);
      if (_titleEl?.renderNode != null) multiNode.addChild(_titleEl!.renderNode!);
    }
    if (widget.content != null) {
      _contentEl = widget.content!.createElement()..mount(this);
      if (_contentEl?.renderNode != null) multiNode.addChild(_contentEl!.renderNode!);
    }

    _actionEls = widget.actions.map((w) {
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
      return el;
    }).toList();
  }

  @override
  void unmount() {
    _titleEl?.unmount();
    _contentEl?.unmount();
    for (final el in _actionEls) {
      el.unmount();
    }
    _actionEls.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_titleEl != null) visitor(_titleEl!);
    if (_contentEl != null) visitor(_contentEl!);
    for (final el in _actionEls) {
      visitor(el);
    }
  }
}

class CupertinoDatePicker extends NativeRenderWidget {
  final DateTime initialDateTime;
  final void Function(DateTime newDateTime)? onDateTimeChanged;

  const CupertinoDatePicker({
    super.key,
    required this.initialDateTime,
    required this.onDateTimeChanged,
  });

  @override
  Element createElement() => CupertinoDatePickerElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return CupertinoDatePickerRenderNode(
      props: {'initialDateTime': initialDateTime.toIso8601String()},
    );
  }
}

class CupertinoDatePickerRenderNode extends NativeRenderNode {
  CupertinoDatePickerRenderNode({required super.props})
      : super(widgetType: 'CupertinoDatePicker');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(Size(
      constraints.maxWidth.isFinite ? constraints.maxWidth : 300.0,
      216.0,
    ));
  }
}

class CupertinoDatePickerElement extends NativeRenderElement {
  CupertinoDatePickerElement(CupertinoDatePicker super.widget);

  @override
  CupertinoDatePicker get widget => super.widget as CupertinoDatePicker;

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
    if (backend != null && widget.onDateTimeChanged != null) {
      backend.registerEventListener(handle, 'dateTimeChange', (name, data) {
        final iso = data['isoString'] as String?;
        if (iso != null) {
          final dt = DateTime.tryParse(iso);
          if (dt != null) widget.onDateTimeChanged?.call(dt);
        }
      });
    }
  }
}

class CupertinoPageScaffold extends NativeRenderWidget {
  final Widget? navigationBar;
  final Widget child;

  const CupertinoPageScaffold({
    super.key,
    this.navigationBar,
    required this.child,
  });

  @override
  Element createElement() => CupertinoPageScaffoldElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'CupertinoPageScaffold');
  }
}

class CupertinoPageScaffoldElement extends NativeRenderElement {
  Element? _navEl;
  Element? _childEl;

  CupertinoPageScaffoldElement(CupertinoPageScaffold super.widget);

  @override
  CupertinoPageScaffold get widget => super.widget as CupertinoPageScaffold;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    if (widget.navigationBar != null) {
      _navEl = widget.navigationBar!.createElement()..mount(this);
      if (_navEl?.renderNode != null) multiNode.addChild(_navEl!.renderNode!);
    }

    _childEl = widget.child.createElement()..mount(this);
    if (_childEl?.renderNode != null) multiNode.addChild(_childEl!.renderNode!);
  }

  @override
  void unmount() {
    _navEl?.unmount();
    _childEl?.unmount();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_navEl != null) visitor(_navEl!);
    if (_childEl != null) visitor(_childEl!);
  }
}
