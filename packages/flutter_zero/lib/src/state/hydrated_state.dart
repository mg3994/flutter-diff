import 'dart:convert';
import 'change_notifier.dart';

abstract class HydratedStateNotifier<T> extends ValueNotifier<T> {
  final String storageKey;

  HydratedStateNotifier(super.initialValue, {required this.storageKey}) {
    final restored = _storage[storageKey];
    if (restored != null) {
      final fromJsonValue = fromJson(jsonDecode(restored) as Map<String, dynamic>);
      if (fromJsonValue != null) {
        value = fromJsonValue;
      }
    }
  }

  static final Map<String, String> _storage = {};

  T? fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson(T state);

  @override
  set value(T newValue) {
    super.value = newValue;
    _storage[storageKey] = jsonEncode(toJson(newValue));
  }

  static void clearStorage() {
    _storage.clear();
  }
}
