import 'animation.dart';

class Keyframe<T> {
  final double fraction;
  final T value;

  const Keyframe(this.fraction, this.value);
}

class KeyframeSequence<T extends num> {
  final List<Keyframe<T>> keyframes;

  KeyframeSequence(this.keyframes) {
    if (keyframes.isEmpty) {
      throw ArgumentError('KeyframeSequence must contain at least one keyframe.');
    }
  }

  double transform(double t) {
    if (t <= keyframes.first.fraction) return keyframes.first.value.toDouble();
    if (t >= keyframes.last.fraction) return keyframes.last.value.toDouble();

    for (int i = 0; i < keyframes.length - 1; i++) {
      final k1 = keyframes[i];
      final k2 = keyframes[i + 1];

      if (t >= k1.fraction && t <= k2.fraction) {
        final localT = (t - k1.fraction) / (k2.fraction - k1.fraction);
        return k1.value + (k2.value - k1.value) * localT;
      }
    }

    return keyframes.last.value.toDouble();
  }

  double evaluate(Animation<double> animation) {
    return transform(animation.value);
  }
}
