import '../backend/native_ui_backend.dart';

class NativeSystemTray {
  static Future<void> setIcon({
    required NativeUIBackend backend,
    required String iconPath,
    String? tooltip,
  }) async {
    backend.dispatchNativeEvent(0, 'setSystemTrayIcon', {
      'iconPath': iconPath,
      'tooltip': tooltip ?? '',
    });
  }

  static Future<void> setMenu({
    required NativeUIBackend backend,
    required List<Map<String, dynamic>> menuItems,
  }) async {
    backend.dispatchNativeEvent(0, 'setSystemTrayMenu', {
      'menuItems': menuItems,
    });
  }
}

class NativeNotificationManager {
  static Future<void> showNotification({
    required NativeUIBackend backend,
    required String title,
    required String body,
    String? iconPath,
  }) async {
    backend.dispatchNativeEvent(0, 'showDesktopNotification', {
      'title': title,
      'body': body,
      'iconPath': iconPath ?? '',
    });
  }
}

class NativeClipboard {
  static String _mockClipboard = '';

  static Future<void> setData(String text) async {
    _mockClipboard = text;
  }

  static Future<String?> getData() async {
    return _mockClipboard;
  }
}
