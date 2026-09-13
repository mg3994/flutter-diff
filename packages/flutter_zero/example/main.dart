import 'package:flutter_zero/flutter_zero.dart';

void main() {
  print('=== Initializing Flutter Zero App with GridView, AnimatedContainer & Slivers ===\n');

  final backend = VirtualNativeUIBackend();

  final app = FlutterZeroApp(
    rootWidget: Container(
      backgroundColor: '#FAFAFA',
      child: Padding(
        padding: 20.0,
        child: Column(
          children: [
            const Text(
              'Flutter Zero GridView, Animations & Slivers',
              fontSize: 18.0,
              color: '#222222',
            ),
            const SizedBox(height: 15.0),
            const AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 100.0,
              height: 40.0,
              backgroundColor: '#0066CC',
              child: Center(child: Text('Animated Container', color: '#FFFFFF')),
            ),
            const SizedBox(height: 15.0),
            GridView(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: const [
                Text('Grid Box 1'),
                Text('Grid Box 2'),
                Text('Grid Box 3'),
                Text('Grid Box 4'),
              ],
            ),
            const SizedBox(height: 15.0),
            const CustomScrollView(
              slivers: [
                SliverList(
                  children: [
                    Text('Sliver List Item A'),
                    Text('Sliver List Item B'),
                  ],
                ),
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
