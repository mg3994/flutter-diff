enum WidgetState {
  hovered,
  focused,
  pressed,
  dragged,
  selected,
  scrolledUnder,
  disabled,
  error,
}

typedef MaterialState = WidgetState;

abstract class WidgetStateProperty<T> {
  T resolve(Set<WidgetState> states);

  static WidgetStateProperty<T> all<T>(T value) =>
      _WidgetStatePropertyAll<T>(value);

  static WidgetStateProperty<T> resolveWith<T>(
          T Function(Set<WidgetState> states) callback) =>
      _WidgetStatePropertyResolveWith<T>(callback);
}

typedef MaterialStateProperty<T> = WidgetStateProperty<T>;

class _WidgetStatePropertyAll<T> implements WidgetStateProperty<T> {
  final T value;

  _WidgetStatePropertyAll(this.value);

  @override
  T resolve(Set<WidgetState> states) => value;
}

class _WidgetStatePropertyResolveWith<T> implements WidgetStateProperty<T> {
  final T Function(Set<WidgetState> states) callback;

  _WidgetStatePropertyResolveWith(this.callback);

  @override
  T resolve(Set<WidgetState> states) => callback(states);
}
