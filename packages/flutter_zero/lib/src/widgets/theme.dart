import '../core/element.dart';
import '../core/widget.dart';

class ThemeData {
  final String primaryColor;
  final String backgroundColor;
  final String textColor;
  final double defaultFontSize;

  const ThemeData({
    this.primaryColor = '#0066CC',
    this.backgroundColor = '#FFFFFF',
    this.textColor = '#333333',
    this.defaultFontSize = 14.0,
  });

  static const ThemeData fallback = ThemeData();
}

class Theme extends InheritedWidget {
  final ThemeData data;

  const Theme({
    super.key,
    required this.data,
    required super.child,
  });

  static ThemeData of(BuildContext context) {
    final themeWidget = context.dependOnInheritedWidgetOfExactType<Theme>();
    return themeWidget?.data ?? ThemeData.fallback;
  }

  @override
  bool updateShouldNotify(Theme oldWidget) {
    return data != oldWidget.data;
  }
}
