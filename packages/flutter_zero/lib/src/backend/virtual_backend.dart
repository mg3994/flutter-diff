import '../core/render_node.dart';
import 'native_ui_backend.dart';

class VirtualNativeView {
  final int handle;
  final String widgetType;
  Map<String, dynamic> props;
  Offset offset = Offset.zero;
  Size size = Size.zero;
  int? parentHandle;
  final List<int> childHandles = [];
  final Map<String, NativeEventListener> eventListeners = {};

  VirtualNativeView({
    required this.handle,
    required this.widgetType,
    required Map<String, dynamic> props,
  }) : props = Map<String, dynamic>.from(props);

  @override
  String toString() {
    return 'VirtualNativeView(id: $handle, type: $widgetType, size: $size, pos: $offset, props: $props, children: ${childHandles.length})';
  }
}

class VirtualNativeUIBackend implements NativeUIBackend {
  int _nextId = 1;
  final Map<int, VirtualNativeView> _views = {};

  Map<int, VirtualNativeView> get views => Map.unmodifiable(_views);

  VirtualNativeView? getView(int handle) => _views[handle];

  @override
  int createView(String widgetType, Map<String, dynamic> props) {
    final handle = _nextId++;
    final view = VirtualNativeView(
      handle: handle,
      widgetType: widgetType,
      props: props,
    );
    _views[handle] = view;
    return handle;
  }

  @override
  void updateView(int handle, Map<String, dynamic> props) {
    final view = _views[handle];
    if (view != null) {
      view.props = Map<String, dynamic>.from(props);
    }
  }

  @override
  void removeView(int handle) {
    final view = _views.remove(handle);
    if (view != null && view.parentHandle != null) {
      final parent = _views[view.parentHandle];
      parent?.childHandles.remove(handle);
    }
  }

  @override
  void appendChild(int parentHandle, int childHandle) {
    final parent = _views[parentHandle];
    final child = _views[childHandle];
    if (parent != null && child != null) {
      child.parentHandle = parentHandle;
      if (!parent.childHandles.contains(childHandle)) {
        parent.childHandles.add(childHandle);
      }
    }
  }

  @override
  void removeChild(int parentHandle, int childHandle) {
    final parent = _views[parentHandle];
    final child = _views[childHandle];
    if (parent != null && child != null) {
      parent.childHandles.remove(childHandle);
      if (child.parentHandle == parentHandle) {
        child.parentHandle = null;
      }
    }
  }

  @override
  void updateLayout(int handle, Offset offset, Size size) {
    final view = _views[handle];
    if (view != null) {
      view.offset = offset;
      view.size = size;
    }
  }

  @override
  void registerEventListener(int handle, String eventName, NativeEventListener listener) {
    final view = _views[handle];
    if (view != null) {
      view.eventListeners[eventName] = listener;
    }
  }

  @override
  void dispatchNativeEvent(int handle, String eventName, Map<String, dynamic> data) {
    final view = _views[handle];
    if (view != null) {
      final listener = view.eventListeners[eventName];
      listener?.call(eventName, data);
    }
  }

  String printTree([int? rootHandle, String indent = '']) {
    final StringBuffer buffer = StringBuffer();
    final handles = rootHandle != null
        ? [rootHandle]
        : _views.values.where((v) => v.parentHandle == null).map((v) => v.handle).toList();

    for (final h in handles) {
      final view = _views[h];
      if (view != null) {
        buffer.writeln('$indent- ${view.widgetType} #${view.handle} props:${view.props} bounds:(${view.offset.dx},${view.offset.dy},${view.size.width}x${view.size.height})');
        for (final childId in view.childHandles) {
          buffer.write(printTree(childId, '$indent  '));
        }
      }
    }
    return buffer.toString();
  }
}
