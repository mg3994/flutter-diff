import 'dart:convert';
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import '../core/render_node.dart';
import 'native_ui_backend.dart';

typedef NativeCreateViewC = ffi.IntPtr Function(ffi.Pointer<Utf8> type, ffi.Pointer<Utf8> propsJson);
typedef NativeCreateViewDart = int Function(ffi.Pointer<Utf8> type, ffi.Pointer<Utf8> propsJson);

typedef NativeUpdateViewC = ffi.Void Function(ffi.IntPtr handle, ffi.Pointer<Utf8> propsJson);
typedef NativeUpdateViewDart = void Function(int handle, ffi.Pointer<Utf8> propsJson);

typedef NativeRemoveViewC = ffi.Void Function(ffi.IntPtr handle);
typedef NativeRemoveViewDart = void Function(int handle);

typedef NativeAttachChildC = ffi.Void Function(ffi.IntPtr parentHandle, ffi.IntPtr childHandle);
typedef NativeAttachChildDart = void Function(int parentHandle, int childHandle);

typedef NativeUpdateLayoutC = ffi.Void Function(ffi.IntPtr handle, ffi.Double x, ffi.Double y, ffi.Double width, ffi.Double height);
typedef NativeUpdateLayoutDart = void Function(int handle, double x, double y, double width, double height);

class FFINativeUIBackend implements NativeUIBackend {
  final ffi.DynamicLibrary? _dylib;
  final NativeCreateViewDart? _createViewFn;
  final NativeUpdateViewDart? _updateViewFn;
  final NativeRemoveViewDart? _removeViewFn;
  final NativeAttachChildDart? _appendChildFn;
  final NativeAttachChildDart? _removeChildFn;
  final NativeUpdateLayoutDart? _updateLayoutFn;

  final Map<int, Map<String, NativeEventListener>> _listeners = {};
  int _fallbackHandleCounter = 1000;

  FFINativeUIBackend({ffi.DynamicLibrary? dylib})
      : _dylib = dylib,
        _createViewFn = dylib?.lookupFunction<NativeCreateViewC, NativeCreateViewDart>('FlutterZero_CreateView'),
        _updateViewFn = dylib?.lookupFunction<NativeUpdateViewC, NativeUpdateViewDart>('FlutterZero_UpdateView'),
        _removeViewFn = dylib?.lookupFunction<NativeRemoveViewC, NativeRemoveViewDart>('FlutterZero_RemoveView'),
        _appendChildFn = dylib?.lookupFunction<NativeAttachChildC, NativeAttachChildDart>('FlutterZero_AppendChild'),
        _removeChildFn = dylib?.lookupFunction<NativeAttachChildC, NativeAttachChildDart>('FlutterZero_RemoveChild'),
        _updateLayoutFn = dylib?.lookupFunction<NativeUpdateLayoutC, NativeUpdateLayoutDart>('FlutterZero_UpdateLayout');

  bool get isNativeLibraryLoaded => _dylib != null;

  @override
  int createView(String widgetType, Map<String, dynamic> props) {
    if (_createViewFn != null) {
      final typePtr = widgetType.toNativeUtf8();
      final propsPtr = jsonEncode(props).toNativeUtf8();
      final handle = _createViewFn!(typePtr, propsPtr);
      calloc.free(typePtr);
      calloc.free(propsPtr);
      return handle;
    }
    return ++_fallbackHandleCounter;
  }

  @override
  void updateView(int handle, Map<String, dynamic> props) {
    if (_updateViewFn != null) {
      final propsPtr = jsonEncode(props).toNativeUtf8();
      _updateViewFn!(handle, propsPtr);
      calloc.free(propsPtr);
    }
  }

  @override
  void removeView(int handle) {
    if (_removeViewFn != null) {
      _removeViewFn!(handle);
    }
    _listeners.remove(handle);
  }

  @override
  void appendChild(int parentHandle, int childHandle) {
    if (_appendChildFn != null) {
      _appendChildFn!(parentHandle, childHandle);
    }
  }

  @override
  void removeChild(int parentHandle, int childHandle) {
    if (_removeChildFn != null) {
      _removeChildFn!(parentHandle, childHandle);
    }
  }

  @override
  void updateLayout(int handle, Offset offset, Size size) {
    if (_updateLayoutFn != null) {
      _updateLayoutFn!(handle, offset.dx, offset.dy, size.width, size.height);
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
}
