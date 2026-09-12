import 'package:flutter_zero/flutter_zero.dart';

final GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              'Flutter Zero Framework with GlobalKey & Image Support',
              fontSize: theme.defaultFontSize + 4.0,
              color: theme.textColor,
            ),
            const SizedBox(height: 15.0),
            Image.network(
              'https://flutter.dev/logo.png',
              width: 120.0,
              height: 40.0,
            ),
            const SizedBox(height: 15.0),
            const Wrap(
              spacing: 10.0,
              children: [
                Chip(label: Text('Dart FFI')),
                Chip(label: Text('Native Platform UI')),
                Chip(label: Text('No Canvas')),
              ],
            ),
            const SizedBox(height: 15.0),
            Form(
              key: formGlobalKey,
              child: Column(
                children: [
                  TextFormField(
                    placeholder: 'Enter profile name...',
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Name is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Button(
                    onPressed: () {
                      final form = formGlobalKey.currentState;
                      if (form != null && form.validate()) {
                        print('Form is valid!');
                      }
                    },
                    child: const Text('Validate Form via GlobalKey'),
                  ),
                ],
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
      child: HomeScreen(),
    ),
    backend: backend,
  );

  print('=== Initializing Flutter Zero App with Image, Wrap & GlobalKey ===');
  app.run();

  print('\n=== Native View Tree on Mount ===');
  print(backend.printTree());
}
