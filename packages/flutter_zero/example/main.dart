import 'package:flutter_zero/flutter_zero.dart';

void main() {
  print('=== Initializing Flutter Zero App with Adaptive Controls & ListView.builder ===\n');

  final backend = VirtualNativeUIBackend();

  final app = FlutterZeroApp(
    rootWidget: Container(
      backgroundColor: '#FAFAFA',
      child: Padding(
        padding: 20.0,
        child: Column(
          children: [
            const Text(
              'Flutter Zero Adaptive Controls & Virtualized List',
              fontSize: 18.0,
              color: '#222222',
            ),
            const SizedBox(height: 15.0),
            Row(
              children: [
                AdaptiveButton(
                  platform: TargetPlatform.iOS,
                  onPressed: () => print('Cupertino Button Clicked!'),
                  child: const Text('Cupertino Native Button'),
                ),
                const SizedBox(width: 10.0),
                const Expanded(
                  child: AdaptiveTextField(
                    placeholder: 'Adaptive native text input...',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemExtent: 35.0,
                itemBuilder: (context, index) {
                  return Text('Virtualized List Item #$index', fontSize: 13.0);
                },
              ),
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
