import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class SimpleDialogOption extends NativeRenderWidget {
  final Widget child;
  final void Function()? onPressed;

  const SimpleDialogOption({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Element createElement() => SimpleDialogOptionElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(widgetType: 'SimpleDialogOption');
  }
}

class SimpleDialogOptionElement extends NativeRenderElement {
  Element? _childElement;

  SimpleDialogOptionElement(SimpleDialogOption super.widget);

  @override
  SimpleDialogOption get widget => super.widget as SimpleDialogOption;

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
    if (backend != null && widget.onPressed != null) {
      backend.registerEventListener(handle, 'click', (eventName, data) {
        widget.onPressed?.call();
      });
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_childElement != null) visitor(_childElement!);
  }
}

class SimpleDialog extends NativeRenderWidget {
  final Widget? title;
  final List<Widget> children;

  const SimpleDialog({
    super.key,
    this.title,
    this.children = const [],
  });

  @override
  Element createElement() => SimpleDialogElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'SimpleDialog');
  }
}

class SimpleDialogElement extends NativeRenderElement {
  Element? _titleEl;
  List<Element> _childEls = [];

  SimpleDialogElement(SimpleDialog super.widget);

  @override
  SimpleDialog get widget => super.widget as SimpleDialog;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    if (widget.title != null) {
      _titleEl = widget.title!.createElement()..mount(this);
      if (_titleEl?.renderNode != null) multiNode.addChild(_titleEl!.renderNode!);
    }

    _childEls = widget.children.map((w) {
      final el = w.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
      return el;
    }).toList();
  }

  @override
  void unmount() {
    _titleEl?.unmount();
    for (final el in _childEls) {
      el.unmount();
    }
    _childEls.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_titleEl != null) visitor(_titleEl!);
    for (final el in _childEls) {
      visitor(el);
    }
  }
}

class AboutDialog extends NativeRenderWidget {
  final String applicationName;
  final String applicationVersion;
  final Widget? applicationIcon;

  const AboutDialog({
    super.key,
    required this.applicationName,
    required this.applicationVersion,
    this.applicationIcon,
  });

  @override
  Element createElement() => AboutDialogElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'AboutDialog',
      props: {
        'name': applicationName,
        'version': applicationVersion,
      },
    );
  }
}

class AboutDialogElement extends NativeRenderElement {
  Element? _iconEl;

  AboutDialogElement(AboutDialog super.widget);

  @override
  AboutDialog get widget => super.widget as AboutDialog;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    if (widget.applicationIcon != null) {
      _iconEl = widget.applicationIcon!.createElement()..mount(this);
      if (_iconEl?.renderNode != null) {
        (renderNode as SingleChildNativeRenderNode).child = _iconEl!.renderNode;
      }
    }
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_iconEl != null) visitor(_iconEl!);
  }
}
