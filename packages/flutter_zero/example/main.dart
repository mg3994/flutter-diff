import 'package:flutter_zero/flutter_zero.dart';

void main() {
  print('=== Initializing Flutter Zero App with JNI, Native Assets & Restoration ===');

  final jniBackend = JNINativeUIBackend();
  final asset = NativeAssetBundle.instance.loadNativeLibrary('libnative_ui.so');

  print('Native asset bundle dynamic library loaded: ${asset != null}');

  final bucket = RestorationBucket();
  final counterState = RestorableInt(0);

  counterState.value = 10;
  counterState.save(bucket, 'counter_key');
  print('Saved restoration bucket value: ${bucket.read<int>('counter_key')}');

  final app = FlutterZeroApp(
    rootWidget: const Container(
      backgroundColor: '#FFFFFF',
      child: Text('Flutter Zero Native JNI & Native Assets Architecture'),
    ),
    backend: jniBackend,
  );

  app.run();

  print('\n=== Serialized JNI Native View Tree ===');
  print(jniBackend.serializeJNIViewTree());
}
