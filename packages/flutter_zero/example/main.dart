import 'package:flutter_zero/flutter_zero.dart';

class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int _counter = 0;
  String _inputText = '';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      backgroundColor: theme.backgroundColor,
      child: Padding(
        padding: 20.0,
        child: Column(
          children: [
            Text(
              'Flutter Zero Advanced Native Rendering Demo',
              fontSize: theme.defaultFontSize + 4.0,
              color: theme.textColor,
            ),
            const SizedBox(height: 10.0),
            Text(
              'Button clicks counter: $_counter | Input: $_inputText',
              fontSize: theme.defaultFontSize,
              color: theme.primaryColor,
            ),
            const SizedBox(height: 15.0),
            Row(
              children: [
                Button(
                  onPressed: _incrementCounter,
                  child: const Text('Increment Counter'),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    placeholder: 'Type native input...',
                    onChanged: (val) {
                      setState(() {
                        _inputText = val;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            GestureDetector(
              onTap: () {
                print('Native GestureDetector tapped!');
              },
              child: Container(
                backgroundColor: '#EEEEEE',
                child: const Padding(
                  padding: 10.0,
                  child: Text('Tap me! (GestureDetector Native Interop)', color: '#008800'),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            Expanded(
              child: ListView(
                itemExtent: 40.0,
                children: List.generate(
                  3,
                  (i) => Text('Native ListView Item #${i + 1}', fontSize: 13.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  final backend = VirtualNativeUIBackend();

  const themeData = ThemeData(
    primaryColor: '#0066CC',
    backgroundColor: '#FAFAFA',
    textColor: '#222222',
  );

  final app = FlutterZeroApp(
    rootWidget: const Theme(
      data: themeData,
      child: CounterApp(),
    ),
    backend: backend,
  );

  print('=== Initializing Flutter Zero App with Theme & Gestures ===');
  app.run();

  print('\n=== Native View Tree After Initial Mount ===');
  print(backend.printTree());

  final buttonViews = backend.views.values.where((v) => v.widgetType == 'Button').toList();
  if (buttonViews.isNotEmpty) {
    final buttonView = buttonViews.first;
    print('\n>>> Simulating native click on Button #${buttonView.handle}...');
    backend.dispatchNativeEvent(buttonView.handle, 'click', {});
  }

  print('\n=== Native View Tree After Reactive State Update ===');
  print(backend.printTree());
}
