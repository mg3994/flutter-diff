import 'package:flutter_zero/flutter_zero.dart';

class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  final ValueNotifier<int> _notifierCounter = ValueNotifier<int>(0);
  String _inputText = '';

  @override
  void dispose() {
    _notifierCounter.dispose();
    super.dispose();
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
              'Flutter Zero Complete Native Platform Framework',
              fontSize: theme.defaultFontSize + 4.0,
              color: theme.textColor,
            ),
            const SizedBox(height: 10.0),
            ValueListenableBuilder<int>(
              valueListenable: _notifierCounter,
              builder: (context, count, child) {
                return Text(
                  'ValueNotifier Counter: $count | Input: $_inputText',
                  fontSize: theme.defaultFontSize,
                  color: theme.primaryColor,
                );
              },
            ),
            const SizedBox(height: 15.0),
            Row(
              children: [
                Button(
                  onPressed: () {
                    _notifierCounter.value++;
                  },
                  child: const Text('Increment ValueNotifier'),
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
            const Text('Embedded Platform Native Views:', fontSize: 14.0),
            const SizedBox(height: 5.0),
            const Row(
              children: [
                Expanded(
                  child: AndroidNativeView(
                    viewType: 'com.example.native_map',
                    creationParams: {'zoom': 12},
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: UIKitNativeView(
                    viewType: 'com.example.native_camera',
                    creationParams: {'quality': 'high'},
                  ),
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

  print('=== Initializing Flutter Zero App with ValueNotifier & Native Views ===');
  app.run();

  print('\n=== Native View Tree After Initial Mount ===');
  print(backend.printTree());

  final buttonViews = backend.views.values.where((v) => v.widgetType == 'Button').toList();
  if (buttonViews.isNotEmpty) {
    final buttonView = buttonViews.first;
    print('\n>>> Simulating native click on ValueNotifier Button #${buttonView.handle}...');
    backend.dispatchNativeEvent(buttonView.handle, 'click', {});
  }

  print('\n=== Native View Tree After Reactive ValueNotifier Update ===');
  print(backend.printTree());
}
