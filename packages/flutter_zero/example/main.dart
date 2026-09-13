import 'package:flutter_zero/flutter_zero.dart';

void main() {
  print('=== Initializing Flutter Zero App with Curves, Image Cache & WindowController ===\n');

  final backend = VirtualNativeUIBackend();

  final parentAnim = AnimationController(duration: const Duration(seconds: 1));
  final curvedAnim = CurvedAnimation(parent: parentAnim, curve: Curves.easeInOut);

  print('Curved Animation value at 0.5: ${curvedAnim.value}');

  NetworkImageCache.instance.cacheImage('https://flutter.dev/logo.png', '/cache/logo.png');
  print('Is image cached: ${NetworkImageCache.instance.isCached('https://flutter.dev/logo.png')}');

  final windowHandle = backend.createView('Window', {'title': 'Main Shell Window'});
  final windowController = WindowController(backend: backend, windowHandle: windowHandle);
  windowController.setTitle('Updated Desktop Shell Title');

  final app = FlutterZeroApp(
    rootWidget: const Container(
      backgroundColor: '#FAFAFA',
      child: Padding(
        padding: 20.0,
        child: Column(
          children: [
            Text('Flutter Zero Desktop & Mobile Native Shell Engine'),
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
