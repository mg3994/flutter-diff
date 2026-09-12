import 'package:flutter_zero/flutter_zero.dart';

class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      backgroundColor: '#FFFFFF',
      child: Padding(
        padding: 20.0,
        child: Column(
          children: [
            const Text(
              'Flutter Zero Native Rendering Demo',
              fontSize: 20.0,
              color: '#333333',
            ),
            const SizedBox(height: 10.0),
            Text(
              'Button clicks counter: $_counter',
              fontSize: 16.0,
              color: '#0066CC',
            ),
            const SizedBox(height: 15.0),
            Row(
              children: [
                Button(
                  onPressed: _incrementCounter,
                  child: const Text('Increment Counter', fontSize: 14.0),
                ),
                const SizedBox(width: 10.0),
                const TextField(
                  placeholder: 'Enter native text input...',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  final backend = VirtualNativeUIBackend();
  final app = FlutterZeroApp(
    rootWidget: const CounterApp(),
    backend: backend,
  );

  print('=== Initializing Flutter Zero App ===');
  app.run();

  print('\n=== Native View Tree After Initial Mount ===');
  print(backend.printTree());

  final buttonViews = backend.views.values.where((v) => v.widgetType == 'Button').toList();
  if (buttonViews.isNotEmpty) {
    final buttonView = buttonViews.first;
    print('\n>>> Simulating native user click event on Button #${buttonView.handle}...');
    backend.registerEventListener(buttonView.handle, 'click', (eventName, data) {
      print('Native event received: $eventName');
    });

    backend.dispatchNativeEvent(buttonView.handle, 'click', {});
  }
}
