import 'package:flutter_zero/flutter_zero.dart';

const methodChannel = MethodChannel('com.flutter_zero/device_info');

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);

    return Container(
      backgroundColor: theme.backgroundColor,
      child: Padding(
        padding: 20.0,
        child: Column(
          children: [
            Text(
              'Flutter Zero Locale: ${locale.languageCode}',
              fontSize: theme.defaultFontSize + 4.0,
              color: theme.textColor,
            ),
            const SizedBox(height: 15.0),
            Button(
              onPressed: () async {
                final String? version = await methodChannel.invokeMethod<String>('getOSVersion');
                print('Native MethodChannel Response: $version');
              },
              child: const Text('Invoke Host Platform MethodChannel'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  final backend = VirtualNativeUIBackend();

  methodChannel.setMethodCallHandler((call) async {
    if (call.method == 'getOSVersion') {
      return 'Flutter Zero Platform v1.0.0 (Native FFI)';
    }
    return null;
  });

  final app = FlutterZeroApp(
    rootWidget: const Localizations(
      locale: Locale('en', 'US'),
      child: HomeScreen(),
    ),
    backend: backend,
  );

  print('=== Initializing Flutter Zero App with Localizations & MethodChannel ===');
  app.run();

  print('\n=== Native Tree Inspector Diagnostic JSON ===');
  final inspector = NativeTreeInspector(backend);
  print(inspector.toJson());
}
