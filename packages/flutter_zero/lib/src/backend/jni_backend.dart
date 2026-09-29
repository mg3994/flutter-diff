import 'dart:convert';
import 'dart:ffi' as ffi;
import '../core/render_node.dart';
import 'native_ui_backend.dart';

class JNINativeUIBackend implements NativeUIBackend {
  final ffi.Pointer<ffi.Void>? envPointer;
  final Map<int, Map<String, dynamic>> _javaViews = {};
  final Map<int, Map<String, NativeEventListener>> _listeners = {};
  int _nextHandle = 5000;

  JNINativeUIBackend({this.envPointer});

  bool get isJNIEnvironmentAvailable => envPointer != null;

  @override
  int createView(String widgetType, Map<String, dynamic> props) {
    final handle = ++_nextHandle;
    _javaViews[handle] = {
      'type': widgetType,
      'props': Map<String, dynamic>.from(props),
      'children': <int>[],
    };
    return handle;
  }

  @override
  void updateView(int handle, Map<String, dynamic> props) {
    final view = _javaViews[handle];
    if (view != null) {
      view['props'] = Map<String, dynamic>.from(props);
    }
  }

  @override
  void removeView(int handle) {
    _javaViews.remove(handle);
    _listeners.remove(handle);
  }

  @override
  void appendChild(int parentHandle, int childHandle) {
    final parent = _javaViews[parentHandle];
    if (parent != null) {
      final children = parent['children'] as List<int>;
      if (!children.contains(childHandle)) {
        children.add(childHandle);
      }
    }
  }

  @override
  void removeChild(int parentHandle, int childHandle) {
    final parent = _javaViews[parentHandle];
    if (parent != null) {
      final children = parent['children'] as List<int>;
      children.remove(childHandle);
    }
  }

  @override
  void updateLayout(int handle, Offset offset, Size size) {
    final view = _javaViews[handle];
    if (view != null) {
      view['offset'] = {'dx': offset.dx, 'dy': offset.dy};
      view['size'] = {'width': size.width, 'height': size.height};
    }
  }

  @override
  void registerEventListener(int handle, String eventName, NativeEventListener listener) {
    _listeners.putIfAbsent(handle, () => {})[eventName] = listener;
  }

  @override
  void dispatchNativeEvent(int handle, String eventName, Map<String, dynamic> data) {
    final listener = _listeners[handle]?[eventName];
    listener?.call(eventName, data);
  }

  String serializeJNIViewTree() {
    final Map<String, dynamic> serializable = {};
    _javaViews.forEach((key, value) {
      serializable[key.toString()] = value;
    });
    return jsonEncode(serializable);
  }
}
