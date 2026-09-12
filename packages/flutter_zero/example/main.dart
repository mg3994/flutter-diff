import 'package:flutter_zero/flutter_zero.dart';

class AppState {
  final String username;
  const AppState(this.username);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formKey = Key('main_form');

    return Container(
      backgroundColor: theme.backgroundColor,
      child: Padding(
        padding: 20.0,
        child: Column(
          children: [
            Text(
              'Flutter Zero Native Application Framework',
              fontSize: theme.defaultFontSize + 4.0,
              color: theme.textColor,
            ),
            const SizedBox(height: 15.0),
            Consumer<AppState>(
              builder: (ctx, state, child) {
                return Text('Injected User: ${state.username}', color: theme.primaryColor);
              },
            ),
            const SizedBox(height: 15.0),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    placeholder: 'Enter username...',
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Username cannot be empty';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Button(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogCtx) => AlertDialog(
                          title: const Text('Modal Dialog'),
                          content: const Text('Native Flutter Zero Dialog Content'),
                          actions: [
                            Button(
                              onPressed: () => Navigator.pop(dialogCtx),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Show Native AlertDialog'),
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
    rootWidget: Provider<AppState>(
      value: const AppState('jules_developer'),
      child: Theme(
        data: themeData,
        child: Navigator(
          initialRoutes: [
            PageRoute(builder: (ctx) => const HomeScreen()),
          ],
        ),
      ),
    ),
    backend: backend,
  );

  print('=== Initializing Flutter Zero App with Form, Provider & Dialog ===');
  app.run();

  print('\n=== Native View Tree on Mount ===');
  print(backend.printTree());

  final buttonViews = backend.views.values.where((v) => v.widgetType == 'Button').toList();
  if (buttonViews.isNotEmpty) {
    final dialogButton = buttonViews.first;
    print('\n>>> Simulating click on "Show AlertDialog" Button #${dialogButton.handle}...');
    backend.dispatchNativeEvent(dialogButton.handle, 'click', {});
  }

  print('\n=== Native View Tree After AlertDialog Overlay ===');
  print(backend.printTree());
}
