import 'package:flutter_zero/flutter_zero.dart';

void main() {
  print('=== Initializing Flutter Zero App with Focus, Tabs & Semantics ===\n');

  final backend = VirtualNativeUIBackend();
  final focusNode = FocusNode();
  final tabController = TabController(length: 2);

  final app = FlutterZeroApp(
    rootWidget: Focus(
      focusNode: focusNode,
      child: Semantics(
        label: 'Main Native Container',
        hint: 'Contains tabs and inputs',
        child: Container(
          backgroundColor: '#FFFFFF',
          child: Column(
            children: [
              TabBar(
                controller: tabController,
                tabs: const [
                  Text('Tab 1'),
                  Text('Tab 2'),
                ],
              ),
              const SizedBox(height: 15.0),
              TextField(
                placeholder: 'Focused Native Input Field...',
              ),
            ],
          ),
        ),
      ),
    ),
    backend: backend,
  );

  app.run();

  focusNode.requestFocus();
  print('Focus requested: ${focusNode.hasFocus}');

  print('\n=== Native View Hierarchy ===');
  print(backend.printTree());
}
