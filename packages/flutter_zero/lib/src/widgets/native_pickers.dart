import '../backend/native_ui_backend.dart';
import '../core/render_node.dart';
import '../theme/style.dart';
import 'widgets.dart';

/// Helper for native system file open/save dialogs.
class NativeFileDialog {
  static Future<String?> pickFile({
    required NativeUIBackend backend,
    String? title,
    List<String>? allowedExtensions,
  }) async {
    return 'file://mock_picked_file.png';
  }

  static Future<String?> saveFile({
    required NativeUIBackend backend,
    String? title,
    String? defaultFileName,
  }) async {
    return 'file://mock_saved_file.png';
  }

  static Future<String?> pickDirectory({
    required NativeUIBackend backend,
    String? title,
  }) async {
    return 'dir://mock_directory';
  }
}

/// Native Date Picker control.
class NativeDatePicker extends NativeRenderWidget {
  final DateTime? initialDate;
  final void Function(DateTime date)? onDateChanged;

  const NativeDatePicker({
    super.key,
    this.initialDate,
    this.onDateChanged,
  });

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'NativeDatePicker',
      props: {
        'initialDate': (initialDate ?? DateTime.now()).toIso8601String(),
      },
    );
  }
}

/// Native Time Picker control.
class NativeTimePicker extends NativeRenderWidget {
  final int hour;
  final int minute;
  final void Function(Map<String, int> time)? onTimeChanged;

  const NativeTimePicker({
    super.key,
    this.hour = 12,
    this.minute = 0,
    this.onTimeChanged,
  });

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'NativeTimePicker',
      props: {
        'hour': hour,
        'minute': minute,
      },
    );
  }
}

/// Native Color Picker control.
class NativeColorPicker extends NativeRenderWidget {
  final Color initialColor;
  final void Function(Color color)? onColorChanged;

  const NativeColorPicker({
    super.key,
    this.initialColor = const Color(0xFF000000),
    this.onColorChanged,
  });

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'NativeColorPicker',
      props: {
        'color': initialColor.toHex(),
      },
    );
  }
}
