import 'package:flutter_zero/flutter_zero.dart';

class CustomUserLoginEvent extends Event {
  final String username;
  const CustomUserLoginEvent(this.username);
}

enum AppStatus { loggedOut, loggingIn, loggedIn }
enum AuthTrigger { login, logout }

void main() async {
  print('=== Initializing Flutter Zero Showcase with EventBus & StateMachine ===\n');

  final backend = VirtualNativeUIBackend();

  EventBus.instance.on<CustomUserLoginEvent>().listen((e) {
    print('EventBus received login event for: ${e.username}');
  });

  final authMachine = StateMachine<AppStatus, AuthTrigger>(
    AppStatus.loggedOut,
    {
      AppStatus.loggedOut: {AuthTrigger.login: AppStatus.loggedIn},
      AppStatus.loggedIn: {AuthTrigger.logout: AppStatus.loggedOut},
    },
  );

  print('Initial Auth Status: ${authMachine.value}');
  authMachine.trigger(AuthTrigger.login);
  print('Auth Status after transition: ${authMachine.value}');

  EventBus.instance.fire(const CustomUserLoginEvent('jules_developer'));

  final app = FlutterZeroApp(
    rootWidget: ValueListenableBuilder<AppStatus>(
      valueListenable: authMachine,
      builder: (ctx, status, child) {
        return Container(
          backgroundColor: '#FAFAFA',
          child: Padding(
            padding: 20.0,
            child: Column(
              children: [
                Text('Auth Status: ${status.name}'),
              ],
            ),
          ),
        );
      },
    ),
    backend: backend,
  );

  app.run();

  print('\n=== Native View Hierarchy ===');
  print(backend.printTree());
}
