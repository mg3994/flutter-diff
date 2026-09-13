import 'package:flutter_zero/flutter_zero.dart';

void main() {
  print('=== Initializing Flutter Zero App with Scaffold, Inputs & Isolate Compute ===\n');

  final backend = VirtualNativeUIBackend();

  final app = FlutterZeroApp(
    rootWidget: Scaffold(
      appBar: Container(
        backgroundColor: '#0066CC',
        child: const Padding(
          padding: 12.0,
          child: Text('Flutter Zero Native Scaffold Bar', color: '#FFFFFF'),
        ),
      ),
      body: Container(
        backgroundColor: '#FAFAFA',
        child: Padding(
          padding: 20.0,
          child: Column(
            children: [
              const Text('Native Form Inputs & Controls:'),
              const SizedBox(height: 10.0),
              Checkbox(value: true, onChanged: (val) {}),
              const SizedBox(height: 10.0),
              Switch(value: true, onChanged: (val) {}),
              const SizedBox(height: 10.0),
              Slider(value: 0.5, onChanged: (val) {}),
            ],
          ),
        ),
      ),
    ),
    backend: backend,
  );

  app.run();

  print('=== Native View Hierarchy ===');
  print(backend.printTree());
}
