import 'dart:async';

abstract class Animation<T> {
  T get value;
  void addListener(void Function() listener);
  void removeListener(void Function() listener);
}

class AnimationController implements Animation<double> {
  final Duration duration;
  final double lowerBound;
  final double upperBound;

  double _value;
  Timer? _timer;
  final List<void Function()> _listeners = [];

  AnimationController({
    required this.duration,
    this.lowerBound = 0.0,
    this.upperBound = 1.0,
    double? initialValue,
  }) : _value = initialValue ?? lowerBound;

  @override
  double get value => _value;

  set value(double newValue) {
    _value = newValue.clamp(lowerBound, upperBound);
    _notifyListeners();
  }

  @override
  void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in List.of(_listeners)) {
      listener();
    }
  }

  void forward() {
    _timer?.cancel();
    const fps = 60;
    final intervalMs = 1000 ~/ fps;
    final totalSteps = duration.inMilliseconds / intervalMs;
    final stepIncrement = (upperBound - lowerBound) / (totalSteps > 0 ? totalSteps : 1);

    _timer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      if (_value + stepIncrement >= upperBound) {
        value = upperBound;
        timer.cancel();
      } else {
        value = _value + stepIncrement;
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }

  void dispose() {
    stop();
    _listeners.clear();
  }
}

class Tween<T extends num> {
  final T begin;
  final T end;

  const Tween({required this.begin, required this.end});

  double transform(double t) {
    return begin + (end - begin) * t;
  }

  double evaluate(Animation<double> animation) {
    return transform(animation.value);
  }
}
