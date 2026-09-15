import '../core/render_node.dart';

typedef NativeEventListener = void Function(String eventName, Map<String, dynamic> data);

abstract class NativeUIBackend {
  int createView(String widgetType, Map<String, dynamic> props);
  void updateView(int handle, Map<String, dynamic> props);
  void removeView(int handle);
  void appendChild(int parentHandle, int childHandle);
  void removeChild(int parentHandle, int childHandle);
  void updateLayout(int handle, Offset offset, Size size);
  void registerEventListener(int handle, String eventName, NativeEventListener listener);
  void dispatchNativeEvent(int handle, String eventName, Map<String, dynamic> data);
}
