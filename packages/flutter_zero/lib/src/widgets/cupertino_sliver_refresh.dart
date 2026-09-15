import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class CupertinoSliverRefreshControl extends NativeRenderWidget {
  final Future<void> Function()? onRefresh;

  const CupertinoSliverRefreshControl({
    super.key,
    this.onRefresh,
  });

  @override
  Element createElement() => CupertinoSliverRefreshControlElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(widgetType: 'CupertinoSliverRefreshControl');
  }
}

class CupertinoSliverRefreshControlElement extends NativeRenderElement {
  CupertinoSliverRefreshControlElement(CupertinoSliverRefreshControl super.widget);

  @override
  CupertinoSliverRefreshControl get widget => super.widget as CupertinoSliverRefreshControl;

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
    if (backend != null && widget.onRefresh != null) {
      backend.registerEventListener(handle, 'refresh', (name, data) async {
        await widget.onRefresh?.call();
      });
    }
  }
}
