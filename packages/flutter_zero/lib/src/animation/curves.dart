import 'dart:math' as math;
import 'animation.dart';

abstract class Curve {
  const Curve();
  double transform(double t);
}

class _LinearCurve extends Curve {
  const _LinearCurve();
  @override
  double transform(double t) => t;
}

class _EaseInOutCurve extends Curve {
  const _EaseInOutCurve();
  @override
  double transform(double t) {
    if (t < 0.5) return 2 * t * t;
    return -1 + (4 - 2 * t) * t;
  }
}

class _BounceOutCurve extends Curve {
  const _BounceOutCurve();
  @override
  double transform(double t) {
    if (t < (1 / 2.75)) {
      return 7.5625 * t * t;
    } else if (t < (2 / 2.75)) {
      final t2 = t - (1.5 / 2.75);
      return 7.5625 * t2 * t2 + 0.75;
    } else if (t < (2.5 / 2.75)) {
      final t2 = t - (2.25 / 2.75);
      return 7.5625 * t2 * t2 + 0.9375;
    } else {
      final t2 = t - (2.625 / 2.75);
      return 7.5625 * t2 * t2 + 0.984375;
    }
  }
}

class Curves {
  static const Curve linear = _LinearCurve();
  static const Curve easeInOut = _EaseInOutCurve();
  static const Curve bounceOut = _BounceOutCurve();
}

class CurvedAnimation implements Animation<double> {
  final Animation<double> parent;
  final Curve curve;

  final List<void Function()> _listeners = [];

  CurvedAnimation({
    required this.parent,
    required this.curve,
  }) {
    parent.addListener(_notify);
  }

  @override
  double get value => curve.transform(parent.value);

  @override
  void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  void _notify() {
    for (final l in List.of(_listeners)) {
      l();
    }
  }

  void dispose() {
    parent.removeListener(_notify);
    _listeners.clear();
  }
}

class SpringSimulation {
  final double stiffness;
  final double damping;

  const SpringSimulation({
    this.stiffness = 100.0,
    this.damping = 10.0,
  });

  double valueAt(double timeInSeconds) {
    final double omega = math.sqrt(stiffness);
    return 1.0 - math.exp(-damping * timeInSeconds) * math.cos(omega * timeInSeconds);
  }
}
