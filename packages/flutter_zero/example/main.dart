import 'package:flutter_zero/flutter_zero.dart';

void main() async {
  print('=== Initializing Flutter Zero Showcase with PointerBridge & ImagePreloader ===\n');

  const url = 'https://flutter.dev/logo.png';
  await AsyncImagePreloader.preload(url);
  print('Image preloaded and cached: ${NetworkImageCache.instance.isCached(url)}');

  final ptr = NativePointerBridge.handleToPointer(0x123456);
  final handle = NativePointerBridge.pointerToHandle(ptr);
  print('FFI Pointer converted to view handle: 0x${handle.toRadixString(16)}');

  final backend = VirtualNativeUIBackend();

  final app = FlutterZeroApp(
    rootWidget: Container(
      backgroundColor: '#FAFAFA',
      child: Padding(
        padding: 20.0,
        child: const Column(
          children: [
            Text('Flutter Zero Complete FFI Pointer Interop & Preloader'),
          ],
        ),
      ),
    ),
    backend: backend,
  );

  app.run();

  print('\n=== Native View Hierarchy ===');
  print(backend.printTree());
}
