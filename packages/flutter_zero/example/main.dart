import 'package:flutter_zero/flutter_zero.dart';

void main() {
  print('=== Initializing Flutter Zero Complete Showcase App ===\n');

  final backend = VirtualNativeUIBackend();
  const tokens = DesignTokens.standard;

  final app = FlutterZeroApp(
    rootWidget: Container(
      backgroundColor: tokens.colors.background,
      child: Padding(
        padding: tokens.mediumSpacing,
        child: Column(
          children: [
            Text(
              'Flutter Zero Canvas-Less Architecture',
              fontSize: 18.0,
              color: tokens.colors.primary,
            ),
            SizedBox(height: tokens.smallSpacing),
            Row(
              children: [
                Chip(label: Text('FFI Interop')),
                SizedBox(width: tokens.smallSpacing),
                Chip(label: Text('JNI Native Views')),
                SizedBox(width: tokens.smallSpacing),
                Chip(label: Text('Zero Canvas')),
              ],
            ),
          ],
        ),
      ),
    ),
    backend: backend,
  );

  app.run();

  print('=== Native View Hierarchy ===');
  print(backend.printTree());
}
