import 'package:flutter_zero/flutter_zero.dart';

void main() async {
  print('=== Initializing Flutter Zero Showcase with TextStyle & EdgeInsets ===\n');

  final backend = VirtualNativeUIBackend();

  final app = FlutterZeroApp(
    rootWidget: Container(
      backgroundColor: '#FAFAFA',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          children: [
            Text(
              'Styled Text with TextStyle',
              style: TextStyle(
                fontSize: 18.0,
                color: const Color(0xFF0066CC),
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: const Text('Custom EdgeInsets Padding'),
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
