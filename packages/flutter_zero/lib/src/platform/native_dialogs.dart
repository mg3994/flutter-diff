class NativeDialogs {
  static Future<bool> showAlert({
    required String title,
    required String message,
    String confirmLabel = 'OK',
    String? cancelLabel,
  }) async {
    return true;
  }

  static Future<DateTime?> showDatePicker({
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    return initialDate;
  }

  static Future<List<String>> showMediaPicker({
    bool allowMultiple = false,
  }) async {
    return ['media://sample_image.png'];
  }
}

Future<bool> showAlert({
  required String title,
  required String message,
  String confirmLabel = 'OK',
  String? cancelLabel,
}) =>
    NativeDialogs.showAlert(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
    );

Future<DateTime?> showDatePicker({
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) =>
    NativeDialogs.showDatePicker(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

Future<List<String>> showMediaPicker({bool allowMultiple = false}) =>
    NativeDialogs.showMediaPicker(allowMultiple: allowMultiple);
