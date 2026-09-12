import 'package:flutter_zero/flutter_zero.dart';
import 'package:test/test.dart';

void main() {
  group('Flutter Zero Framework Tests', () {
    test('VirtualNativeUIBackend creates and hierarchy correctly', () {
      final backend = VirtualNativeUIBackend();

      final rootHandle = backend.createView('Container', {'width': 400, 'height': 300});
      final textHandle = backend.createView('Text', {'text': 'Hello Zero'});

      backend.appendChild(rootHandle, textHandle);
      backend.updateLayout(rootHandle, Offset.zero, const Size(400, 300));
      backend.updateLayout(textHandle, const Offset(10, 10), const Size(100, 20));

      final root = backend.getView(rootHandle);
      final text = backend.getView(textHandle);

      expect(root, isNotNull);
      expect(text, isNotNull);
      expect(root!.childHandles, contains(textHandle));
      expect(text!.parentHandle, equals(rootHandle));
      expect(root.size, equals(const Size(400, 300)));
      expect(text.offset, equals(const Offset(10, 10)));
    });

    test('FFINativeUIBackend initializes correctly', () {
      final backend = FFINativeUIBackend();
      expect(backend.isNativeLibraryLoaded, isFalse);

      final handle = backend.createView('Button', {'enabled': true});
      expect(handle > 0, isTrue);

      backend.updateView(handle, {'enabled': false});
      backend.removeView(handle);
    });

    test('Widget & Element lifecycle mount and reconciliation', () {
      final backend = VirtualNativeUIBackend();
      final app = FlutterZeroApp(
        rootWidget: const Container(
          width: 200.0,
          height: 100.0,
          child: Text('Initial Text'),
        ),
        backend: backend,
      );

      app.run();

      expect(backend.views.length, equals(2));
      final containerView = backend.views.values.firstWhere((v) => v.widgetType == 'Container');
      final textView = backend.views.values.firstWhere((v) => v.widgetType == 'Text');

      expect(containerView.props['width'], equals(200.0));
      expect(textView.props['text'], equals('Initial Text'));

      app.update(const Container(
        width: 300.0,
        height: 100.0,
        child: Text('Updated Text'),
      ));

      expect(containerView.props['width'], equals(300.0));
      expect(textView.props['text'], equals('Updated Text'));
    });

    test('StatefulWidget state management & state updates', () {
      final backend = VirtualNativeUIBackend();

      late void Function() triggerIncrement;

      Widget buildApp() {
        return _TestStatefulWidget(onRegister: (cb) => triggerIncrement = cb);
      }

      final app = FlutterZeroApp(rootWidget: buildApp(), backend: backend);
      app.run();

      var textViews = backend.views.values.where((v) => v.widgetType == 'Text');
      expect(textViews.first.props['text'], equals('Count: 0'));

      triggerIncrement();
      app.update(buildApp());

      textViews = backend.views.values.where((v) => v.widgetType == 'Text');
      expect(textViews.first.props['text'], equals('Count: 1'));
    });

    test('Layout engine box constraints and child offsets calculation', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: const Column(
          children: [
            Text('First Line', fontSize: 10.0), // width: 6.0, height: 12.0
            Text('Second Line', fontSize: 10.0), // width: 6.6, height: 12.0
          ],
        ),
        backend: backend,
      );

      app.run();

      final columnView = backend.views.values.firstWhere((v) => v.widgetType == 'Column');
      final textViews = backend.views.values.where((v) => v.widgetType == 'Text').toList();

      expect(columnView.size.height >= 24.0, isTrue);
      expect(textViews[0].offset, equals(Offset.zero));
      expect(textViews[1].offset.dy, equals(textViews[0].size.height));
    });

    test('Native event dispatching & registration', () {
      final backend = VirtualNativeUIBackend();
      bool eventFired = false;
      Map<String, dynamic>? eventData;

      final handle = backend.createView('Button', {});
      backend.registerEventListener(handle, 'click', (name, data) {
        eventFired = true;
        eventData = data;
      });

      backend.dispatchNativeEvent(handle, 'click', {'x': 10, 'y': 20});

      expect(eventFired, isTrue);
      expect(eventData, equals({'x': 10, 'y': 20}));
    });
  });
}

class _TestStatefulWidget extends StatefulWidget {
  final void Function(void Function()) onRegister;
  const _TestStatefulWidget({required this.onRegister});

  @override
  State<_TestStatefulWidget> createState() => _TestStatefulWidgetState();
}

class _TestStatefulWidgetState extends State<_TestStatefulWidget> {
  int _count = 0;

  @override
  void initState() {
    super.initState();
    widget.onRegister(() {
      setState(() {
        _count++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('Count: $_count');
  }
}
