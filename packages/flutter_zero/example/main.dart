import 'package:flutter_zero/flutter_zero.dart';

void main() async {
  print('=== Initializing Flutter Zero Showcase with Transform, ClipRRect & PopupMenu ===\n');

  final backend = VirtualNativeUIBackend();

  if (rootBundle is NetworkAssetBundle) {
    (rootBundle as NetworkAssetBundle).registerMockAsset('config.json', '{"app": "Flutter Zero"}');
  }

  final configText = await rootBundle.loadString('config.json');
  print('Loaded asset string: $configText');

  final app = FlutterZeroApp(
    rootWidget: Container(
      backgroundColor: '#FAFAFA',
      child: Padding(
        padding: 20.0,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: 12.0,
              child: Transform.scale(
                scale: 1.1,
                child: Container(
                  backgroundColor: '#0066CC',
                  child: const Padding(
                    padding: 10.0,
                    child: Text('Clipped & Scaled Container', color: '#FFFFFF'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            PopupMenuButton<String>(
              items: const [
                PopupMenuItem(value: 'opt1', child: Text('Option 1')),
                PopupMenuItem(value: 'opt2', child: Text('Option 2')),
              ],
              onSelected: (val) {
                print('Selected popup item: $val');
              },
            ),
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
