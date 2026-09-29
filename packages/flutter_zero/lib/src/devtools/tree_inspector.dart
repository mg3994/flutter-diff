import '../backend/virtual_backend.dart';

class NativeTreeInspector {
  final VirtualNativeUIBackend backend;

  const NativeTreeInspector(this.backend);

  Map<String, dynamic> toJson([int? rootHandle]) {
    final Map<String, dynamic> result = {};
    final handles = rootHandle != null
        ? [rootHandle]
        : backend.views.values.where((v) => v.parentHandle == null).map((v) => v.handle).toList();

    result['rootCount'] = handles.length;
    result['views'] = handles.map((h) => _inspectViewNode(h)).toList();
    return result;
  }

  Map<String, dynamic> _inspectViewNode(int handle) {
    final view = backend.getView(handle);
    if (view == null) return {};

    return {
      'handle': view.handle,
      'widgetType': view.widgetType,
      'props': view.props,
      'bounds': {
        'x': view.offset.dx,
        'y': view.offset.dy,
        'width': view.size.width,
        'height': view.size.height,
      },
      'children': view.childHandles.map((ch) => _inspectViewNode(ch)).toList(),
    };
  }
}
