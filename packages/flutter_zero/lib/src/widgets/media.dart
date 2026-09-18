import '../core/render_node.dart';
import 'widgets.dart';

class NativeMediaPlayerWidget extends NativeRenderWidget {
  final String mediaUrl;
  final bool autoPlay;
  final bool looping;

  const NativeMediaPlayerWidget({
    super.key,
    required this.mediaUrl,
    this.autoPlay = false,
    this.looping = false,
  });

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'NativeMediaPlayer',
      props: {
        'mediaUrl': mediaUrl,
        'autoPlay': autoPlay,
        'looping': looping,
      },
    );
  }
}
