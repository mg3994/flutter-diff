import 'dart:async';
import 'package:flutter_zero/flutter_zero.dart';

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
              'Flutter Zero Screen #1 (Navigator Home)',
              fontSize: theme.defaultFontSize + 4.0,
              color: theme.textColor,
            ),
            const SizedBox(height: 15.0),
            Button(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRoute(
                    builder: (ctx) => const DetailScreen(),
                  ),
                );
              },
              child: const Text('Push Detail Screen via Navigator'),
            ),
            const SizedBox(height: 15.0),
            FutureBuilder<String>(
              future: Future.value('Async Data Loaded via FutureBuilder'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(snapshot.data ?? '', color: theme.primaryColor);
                }
                return const Text('Loading async future data...');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      backgroundColor: '#EEEEEE',
      child: Padding(
        padding: 20.0,
        child: Column(
          children: [
            Text(
              'Flutter Zero Screen #2 (Detail Screen)',
              fontSize: theme.defaultFontSize + 4.0,
              color: theme.textColor,
            ),
            const SizedBox(height: 15.0),
            Button(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Pop Back to Home Screen'),
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
    rootWidget: Theme(
      data: themeData,
      child: Navigator(
        initialRoutes: [
          PageRoute(builder: (ctx) => const HomeScreen()),
        ],
      ),
    ),
    backend: backend,
  );

  print('=== Initializing Flutter Zero App with Navigator & FutureBuilder ===');
  app.run();

  print('\n=== Native View Tree on Home Screen ===');
  print(backend.printTree());

  final buttonViews = backend.views.values.where((v) => v.widgetType == 'Button').toList();
  if (buttonViews.isNotEmpty) {
    final buttonView = buttonViews.first;
    print('\n>>> Simulating click on "Push Detail Screen" Button #${buttonView.handle}...');
    backend.dispatchNativeEvent(buttonView.handle, 'click', {});
  }

  print('\n=== Native View Tree After Navigator Push ===');
  print(backend.printTree());
}
