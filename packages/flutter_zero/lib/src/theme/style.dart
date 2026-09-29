class Color {
  final int value;

  const Color(this.value);

  const Color.fromARGB(int a, int r, int g, int b)
      : value = (((a & 0xff) << 24) |
                 ((r & 0xff) << 16) |
                 ((g & 0xff) << 8) |
                 (b & 0xff)) & 0xFFFFFFFF;

  String toHex() {
    return '#${value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }
}

class EdgeInsets {
  final double top;
  final double left;
  final double right;
  final double bottom;

  const EdgeInsets.only({
    this.top = 0.0,
    this.left = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
  });

  const EdgeInsets.all(double value)
      : top = value,
        left = value,
        right = value,
        bottom = value;

  const EdgeInsets.symmetric({
    double vertical = 0.0,
    double horizontal = 0.0,
  })  : top = vertical,
        bottom = vertical,
        left = horizontal,
        right = horizontal;

  static const EdgeInsets zero = EdgeInsets.all(0.0);

  double get horizontalWidth => left + right;
  double get verticalHeight => top + bottom;
}

class TextStyle {
  final double? fontSize;
  final Color? color;
  final String? fontWeight;

  const TextStyle({
    this.fontSize,
    this.color,
    this.fontWeight,
  });
}

class ZeroThemeEngine {
  static bool _isDarkMode = false;

  static bool get isDarkMode => _isDarkMode;

  static void setDarkMode(bool isDark) {
    _isDarkMode = isDark;
  }
}
