import 'package:flutter_zero/flutter_zero.dart';

void main() {
  print('=== Running Flutter Zero Performance Benchmark ===\n');

  final backend = VirtualNativeUIBackend();

  final stopwatch = Stopwatch()..start();

  const int itemCount = 500;
  final app = FlutterZeroApp(
    rootWidget: Container(
      backgroundColor: '#FFFFFF',
      child: Column(
        children: List.generate(
          itemCount,
          (i) => Text('Benchmark Item #$i', fontSize: 14.0),
        ),
      ),
    ),
    backend: backend,
  );

  app.run();
  stopwatch.stop();

  print('1. Initial Mount ($itemCount widgets):');
  print('   - Duration: ${stopwatch.elapsedMicroseconds / 1000.0} ms');
  print('   - Native Views Created: ${backend.views.length}');

  stopwatch.reset();
  stopwatch.start();

  app.update(
    Container(
      backgroundColor: '#FAFAFA',
      child: Column(
        children: List.generate(
          itemCount,
          (i) => Text('Updated Benchmark Item #$i', fontSize: 14.0),
        ),
      ),
    ),
  );

  stopwatch.stop();

  print('\n2. Reactive Tree Reconciliation & Update ($itemCount widgets):');
  print('   - Duration: ${stopwatch.elapsedMicroseconds / 1000.0} ms');
  print('   - Native Views Reused: ${backend.views.length}');
  print('\n=== Benchmark Complete ===');
}
