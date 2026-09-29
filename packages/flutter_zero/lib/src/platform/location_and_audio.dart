import 'dart:async';
import '../core/render_node.dart';
import '../widgets/widgets.dart';

class ZeroLocationData {
  final double latitude;
  final double longitude;
  final double accuracy;

  const ZeroLocationData({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });
}

class ZeroLocationService {
  static Future<bool> isLocationPermissionGranted() async {
    return true;
  }

  static Future<ZeroLocationData> getCurrentLocation() async {
    return const ZeroLocationData(
      latitude: 37.7749,
      longitude: -122.4194,
      accuracy: 5.0,
    );
  }
}

class NativeAudioRecorder extends NativeRenderWidget {
  final void Function(String audioFilePath)? onRecordingFinished;

  const NativeAudioRecorder({
    super.key,
    this.onRecordingFinished,
  });

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'NativeAudioRecorder',
      props: {},
    );
  }
}
