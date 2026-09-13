import 'package:flutter_zero/flutter_zero.dart';

class SamplePlugin extends FlutterZeroPlugin {
  SamplePlugin() : super('sample_plugin');

  @override
  void onAppInit() {
    print('SamplePlugin initialized!');
  }

  @override
  void onNativeEvent(String eventName, Map<String, dynamic> data) {
    print('SamplePlugin received native event: $eventName');
  }
}

void main() {
  print('=== Initializing Flutter Zero App with KeyframeSequence & PluginRegistry ===\n');

  PluginRegistry.register(SamplePlugin());

  final seq = KeyframeSequence<double>([
    const Keyframe(0.0, 0.0),
    const Keyframe(0.5, 100.0),
    const Keyframe(1.0, 200.0),
  ]);

  print('Keyframe sequence value at fraction 0.5: ${seq.transform(0.5)}');

  final backend = VirtualNativeUIBackend();

  final app = FlutterZeroApp(
    rootWidget: const Container(
      backgroundColor: '#FAFAFA',
      child: Padding(
        padding: 20.0,
        child: Column(
          children: [
            Text('Flutter Zero Extensible Native Engine Architecture'),
          ],
        ),
      ),
    ),
    backend: backend,
  );

  app.run();

  PluginRegistry.dispatchNativeEvent('app_ready', {'status': 'ok'});

  print('\n=== Native View Hierarchy ===');
  print(backend.printTree());
}
