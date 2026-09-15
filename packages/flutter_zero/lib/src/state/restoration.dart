class RestorationBucket {
  final Map<String, dynamic> _data = {};

  void write<T>(String key, T value) {
    _data[key] = value;
  }

  T? read<T>(String key) {
    return _data[key] as T?;
  }

  bool contains(String key) => _data.containsKey(key);

  Map<String, dynamic> get data => Map.unmodifiable(_data);
}

abstract class RestorableProperty<T> {
  T _value;

  RestorableProperty(this._value);

  T get value => _value;

  set value(T newValue) {
    _value = newValue;
  }

  void save(RestorationBucket bucket, String key) {
    bucket.write(key, _value);
  }

  void restore(RestorationBucket bucket, String key) {
    if (bucket.contains(key)) {
      final restored = bucket.read<T>(key);
      if (restored != null) {
        _value = restored;
      }
    }
  }
}

class RestorableString extends RestorableProperty<String> {
  RestorableString(super.initialValue);
}

class RestorableInt extends RestorableProperty<int> {
  RestorableInt(super.initialValue);
}
