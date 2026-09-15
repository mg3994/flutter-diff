import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';

enum Orientation { portrait, landscape }

class MediaQueryData {
  final Size size;
  final double devicePixelRatio;

  const MediaQueryData({
    this.size = const Size(800.0, 600.0),
    this.devicePixelRatio = 1.0,
  });

  Orientation get orientation =>
      size.width >= size.height ? Orientation.landscape : Orientation.portrait;

  static const MediaQueryData fallback = MediaQueryData();

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is MediaQueryData &&
        other.size == size &&
        other.devicePixelRatio == devicePixelRatio;
  }

  @override
  int get hashCode => Object.hash(size, devicePixelRatio);
}

class MediaQuery extends InheritedWidget {
  final MediaQueryData data;

  const MediaQuery({
    super.key,
    required this.data,
    required super.child,
  });

  static MediaQueryData of(BuildContext context) {
    final mediaQuery = context.dependOnInheritedWidgetOfExactType<MediaQuery>();
    return mediaQuery?.data ?? MediaQueryData.fallback;
  }

  @override
  bool updateShouldNotify(MediaQuery oldWidget) => data != oldWidget.data;
}
