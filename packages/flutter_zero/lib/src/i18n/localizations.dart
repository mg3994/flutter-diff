import '../core/element.dart';
import '../core/widget.dart';

class Locale {
  final String languageCode;
  final String? countryCode;

  const Locale(this.languageCode, [this.countryCode]);

  @override
  String toString() => countryCode == null ? languageCode : '${languageCode}_$countryCode';

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is Locale &&
        other.languageCode == languageCode &&
        other.countryCode == countryCode;
  }

  @override
  int get hashCode => Object.hash(languageCode, countryCode);
}

abstract class LocalizationsDelegate<T> {
  bool isSupported(Locale locale);
  Future<T> load(Locale locale);
  bool shouldReload(covariant LocalizationsDelegate<T> old);
}

class Localizations extends InheritedWidget {
  final Locale locale;

  const Localizations({
    super.key,
    required this.locale,
    required super.child,
  });

  static Locale localeOf(BuildContext context) {
    final loc = context.dependOnInheritedWidgetOfExactType<Localizations>();
    return loc?.locale ?? const Locale('en');
  }

  @override
  bool updateShouldNotify(Localizations oldWidget) => locale != oldWidget.locale;
}
