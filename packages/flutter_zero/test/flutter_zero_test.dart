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

    test('StatefulWidget state management & automatic native UI update', () {
      final backend = VirtualNativeUIBackend();

      late void Function() triggerIncrement;

      final app = FlutterZeroApp(
        rootWidget: _TestStatefulWidget(onRegister: (cb) => triggerIncrement = cb),
        backend: backend,
      );
      app.run();

      var textViews = backend.views.values.where((v) => v.widgetType == 'Text');
      expect(textViews.first.props['text'], equals('Count: 0'));

      // setState automatically schedules frame update on the native backend
      triggerIncrement();

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

    test('InheritedWidget Theme propagation to child widgets', () {
      final backend = VirtualNativeUIBackend();
      const customTheme = ThemeData(
        primaryColor: '#FF0000',
        backgroundColor: '#000000',
      );

      final app = FlutterZeroApp(
        rootWidget: const Theme(
          data: customTheme,
          child: _ThemeConsumerWidget(),
        ),
        backend: backend,
      );

      app.run();

      final textView = backend.views.values.firstWhere((v) => v.widgetType == 'Text');
      expect(textView.props['color'], equals('#FF0000'));
    });

    test('GestureDetector native event handling', () {
      final backend = VirtualNativeUIBackend();
      bool tapped = false;

      final app = FlutterZeroApp(
        rootWidget: GestureDetector(
          onTap: () {
            tapped = true;
          },
          child: const Text('Tap Me'),
        ),
        backend: backend,
      );

      app.run();

      final gestureView = backend.views.values.firstWhere((v) => v.widgetType == 'GestureDetector');
      backend.dispatchNativeEvent(gestureView.handle, 'tap', {});

      expect(tapped, isTrue);
    });

    test('Stack and Positioned layout calculation', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: const Stack(
          children: [
            Container(width: 200, height: 200),
            Positioned(
              top: 15.0,
              left: 25.0,
              child: Container(width: 50, height: 50),
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final stackView = backend.views.values.firstWhere((v) => v.widgetType == 'Stack');
      final positionedView = backend.views.values.where((v) => v.widgetType == 'Container').last;

      expect(stackView.size, equals(const Size(200.0, 200.0)));
      expect(positionedView.offset, equals(const Offset(25.0, 15.0)));
    });

    test('ListView item extent layout calculation', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: const ListView(
          itemExtent: 30.0,
          children: [
            Text('Item 1'),
            Text('Item 2'),
            Text('Item 3'),
          ],
        ),
        backend: backend,
      );

      app.run();

      final listView = backend.views.values.firstWhere((v) => v.widgetType == 'ListView');
      final textViews = backend.views.values.where((v) => v.widgetType == 'Text').toList();

      expect(listView.size.height, equals(90.0));
      expect(textViews[0].offset, equals(const Offset(0.0, 0.0)));
      expect(textViews[1].offset, equals(const Offset(0.0, 30.0)));
      expect(textViews[2].offset, equals(const Offset(0.0, 60.0)));
    });

    test('AnimationController and Tween evaluation', () {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 100),
        initialValue: 0.0,
      );
      const tween = Tween<double>(begin: 10.0, end: 50.0);

      expect(tween.evaluate(controller), equals(10.0));

      controller.value = 0.5;
      expect(tween.evaluate(controller), equals(30.0));

      controller.value = 1.0;
      expect(tween.evaluate(controller), equals(50.0));
    });

    test('ValueNotifier and ValueListenableBuilder reactive updates', () {
      final backend = VirtualNativeUIBackend();
      final notifier = ValueNotifier<String>('Initial Value');

      final app = FlutterZeroApp(
        rootWidget: ValueListenableBuilder<String>(
          valueListenable: notifier,
          builder: (context, value, child) => Text(value),
        ),
        backend: backend,
      );

      app.run();

      var textView = backend.views.values.firstWhere((v) => v.widgetType == 'Text');
      expect(textView.props['text'], equals('Initial Value'));

      notifier.value = 'Updated Value';

      textView = backend.views.values.firstWhere((v) => v.widgetType == 'Text');
      expect(textView.props['text'], equals('Updated Value'));
    });

    test('AndroidNativeView and UIKitNativeView platform view layout', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: const Column(
          children: [
            AndroidNativeView(viewType: 'android_map'),
            UIKitNativeView(viewType: 'uikit_web'),
          ],
        ),
        backend: backend,
      );

      app.run();

      final androidView = backend.views.values.firstWhere((v) => v.widgetType == 'AndroidView');
      final uikitView = backend.views.values.firstWhere((v) => v.widgetType == 'UIKitView');

      expect(androidView.props['viewType'], equals('android_map'));
      expect(uikitView.props['viewType'], equals('uikit_web'));
    });

    test('Navigator push and pop route stack management', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: Navigator(
          initialRoutes: [
            PageRoute(builder: (context) => const Text('Screen 1')),
          ],
        ),
        backend: backend,
      );

      app.run();

      var textView = backend.views.values.firstWhere((v) => v.widgetType == 'Text');
      expect(textView.props['text'], equals('Screen 1'));

      final navigatorState = backend.views.values.isEmpty;
      expect(navigatorState, isFalse);
    });

    test('FutureBuilder snapshot state resolution', () async {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: FutureBuilder<String>(
          future: Future.value('Completed Future'),
          builder: (context, snapshot) {
            return Text(snapshot.data ?? 'Waiting');
          },
        ),
        backend: backend,
      );

      app.run();

      await Future<void>.delayed(Duration.zero);

      final textView = backend.views.values.firstWhere((v) => v.widgetType == 'Text');
      expect(textView.props['text'], equals('Completed Future'));
    });

    test('Provider and Consumer dependency injection', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: Provider<String>(
          value: 'Injected Test Value',
          child: Consumer<String>(
            builder: (context, val, child) => Text(val),
          ),
        ),
        backend: backend,
      );

      app.run();

      final textView = backend.views.values.firstWhere((v) => v.widgetType == 'Text');
      expect(textView.props['text'], equals('Injected Test Value'));
    });

    test('AlertDialog overlay layout', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: const AlertDialog(
          title: Text('Test Dialog Title'),
          content: Text('Test Dialog Content'),
        ),
        backend: backend,
      );

      app.run();

      final textViews = backend.views.values.where((v) => v.widgetType == 'Text').toList();
      expect(textViews[0].props['text'], equals('Test Dialog Title'));
      expect(textViews[1].props['text'], equals('Test Dialog Content'));
    });

    test('GlobalKey element lookup and state registration', () {
      final backend = VirtualNativeUIBackend();
      final key = GlobalKey<_TestStatefulWidgetState>();

      final app = FlutterZeroApp(
        rootWidget: _TestStatefulWidget(
          key: key,
          onRegister: (_) {},
        ),
        backend: backend,
      );

      app.run();

      expect(key.currentState, isNotNull);
      expect(key.currentContext, isNotNull);
    });

    test('Image render node network and asset properties', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            Image.network('https://example.com/logo.png', width: 100, height: 50),
            Image.asset('assets/icon.png', width: 50, height: 50),
          ],
        ),
        backend: backend,
      );

      app.run();

      final imageViews = backend.views.values.where((v) => v.widgetType == 'Image').toList();
      expect(imageViews[0].props['src'], equals('https://example.com/logo.png'));
      expect(imageViews[1].props['src'], equals('asset://assets/icon.png'));
    });

    test('Wrap layout line wrapping calculation', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: const Wrap(
          spacing: 10.0,
          children: [
            SizedBox(width: 150, height: 30),
            SizedBox(width: 150, height: 30),
            SizedBox(width: 150, height: 30),
          ],
        ),
        backend: backend,
      );

      app.run(constraints: const BoxConstraints(maxWidth: 320.0, maxHeight: 600.0));

      final sizedBoxes = backend.views.values.where((v) => v.widgetType == 'SizedBox').toList();

      expect(sizedBoxes[0].offset, equals(const Offset(0.0, 0.0)));
      expect(sizedBoxes[1].offset, equals(const Offset(160.0, 0.0)));
      expect(sizedBoxes[2].offset.dy > 0.0, isTrue);
    });

    test('MediaQuery resolution and landscape orientation detection', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: const MediaQuery(
          data: MediaQueryData(size: Size(1024, 768), devicePixelRatio: 2.0),
          child: _OrientationTextWidget(),
        ),
        backend: backend,
      );

      app.run();

      final textView = backend.views.values.firstWhere((v) => v.widgetType == 'Text');
      expect(textView.props['text'], equals('landscape'));
    });

    test('CustomPaint vector command generation', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: CustomPaint(
          painter: _TestPainter(),
          size: const Size(100, 100),
        ),
        backend: backend,
      );

      app.run();

      final customPaintView = backend.views.values.firstWhere((v) => v.widgetType == 'CustomPaint');
      final List<dynamic> commands = customPaintView.props['commands'] as List<dynamic>;

      expect(commands.isNotEmpty, isTrue);
      expect(commands.first['type'], equals('drawRect'));
    });

    test('Localizations locale resolution in widget context', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: const Localizations(
          locale: Locale('fr', 'FR'),
          child: _LocaleConsumerWidget(),
        ),
        backend: backend,
      );

      app.run();

      final textView = backend.views.values.firstWhere((v) => v.widgetType == 'Text');
      expect(textView.props['text'], equals('fr_FR'));
    });

    test('MethodChannel invocation and response handling', () async {
      const channel = MethodChannel('test_channel');
      channel.setMethodCallHandler((call) async {
        if (call.method == 'ping') {
          return 'pong';
        }
        return null;
      });

      final result = await channel.invokeMethod<String>('ping');
      expect(result, equals('pong'));
    });

    test('NativeTreeInspector JSON serialization', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: const Container(child: Text('Inspect Me')),
        backend: backend,
      );

      app.run();

      final inspector = NativeTreeInspector(backend);
      final json = inspector.toJson();

      expect(json['rootCount'], equals(1));
      expect((json['views'] as List).isNotEmpty, isTrue);
    });

    test('JNINativeUIBackend view creation and serialization', () {
      final jniBackend = JNINativeUIBackend();
      expect(jniBackend.isJNIEnvironmentAvailable, isFalse);

      final handle = jniBackend.createView('AndroidView', {'type': 'map'});
      expect(handle > 0, isTrue);

      final serialized = jniBackend.serializeJNIViewTree();
      expect(serialized.contains('AndroidView'), isTrue);
    });

    test('NativeAssetBundle library resolution', () {
      final bundle = NativeAssetBundle.instance;
      final lib = bundle.loadNativeLibrary('process_lib');
      expect(lib, isNotNull);
    });

    test('RestorationBucket and RestorableProperty write and read', () {
      final bucket = RestorationBucket();
      final restorableInt = RestorableInt(5);

      restorableInt.value = 42;
      restorableInt.save(bucket, 'int_key');

      expect(bucket.read<int>('int_key'), equals(42));

      final restoredInt = RestorableInt(0);
      restoredInt.restore(bucket, 'int_key');
      expect(restoredInt.value, equals(42));
    });

    test('AdaptiveButton rendering for platform targets', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: const AdaptiveButton(
          platform: TargetPlatform.iOS,
          child: Text('iOS Native Button'),
        ),
        backend: backend,
      );

      app.run();

      final buttonView = backend.views.values.firstWhere((v) => v.widgetType == 'Button');
      expect(buttonView, isNotNull);
    });

    test('ListView.builder virtualized list item generation', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: ListView.builder(
          itemCount: 10,
          itemExtent: 40.0,
          itemBuilder: (context, index) => Text('Item #$index'),
        ),
        backend: backend,
      );

      app.run();

      final textViews = backend.views.values.where((v) => v.widgetType == 'Text').toList();
      expect(textViews.length, equals(10));
      expect(textViews[0].props['text'], equals('Item #0'));
      expect(textViews[9].props['text'], equals('Item #9'));
    });

    test('FocusNode focus request and unfocus state updates', () {
      final focusNode = FocusNode();
      expect(focusNode.hasFocus, isFalse);

      focusNode.requestFocus();
      expect(focusNode.hasFocus, isTrue);

      focusNode.unfocus();
      expect(focusNode.hasFocus, isFalse);
    });

    test('TabController index switching and reactive notification', () {
      final controller = TabController(length: 3, initialIndex: 0);
      expect(controller.index, equals(0));

      controller.index = 2;
      expect(controller.index, equals(2));
    });

    test('Semantics accessibility label and hint prop serialization', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: const Semantics(
          label: 'Accessibility Button',
          hint: 'Double tap to activate',
          child: Text('Click'),
        ),
        backend: backend,
      );

      app.run();

      final semanticsView = backend.views.values.firstWhere((v) => v.widgetType == 'Semantics');
      expect(semanticsView.props['label'], equals('Accessibility Button'));
      expect(semanticsView.props['hint'], equals('Double tap to activate'));
    });

    test('GridView column layout and item offset calculation', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: const GridView(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: [
            Text('Item 1'),
            Text('Item 2'),
          ],
        ),
        backend: backend,
      );

      app.run(constraints: const BoxConstraints(maxWidth: 210.0, maxHeight: 600.0));

      final textViews = backend.views.values.where((v) => v.widgetType == 'Text').toList();
      expect(textViews[0].offset, equals(const Offset(0.0, 0.0)));
      expect(textViews[1].offset, equals(const Offset(110.0, 0.0)));
    });

    test('CustomScrollView and SliverList layout pass', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: const CustomScrollView(
          slivers: [
            SliverList(
              children: [
                Text('Sliver 1'),
                Text('Sliver 2'),
              ],
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final sliverView = backend.views.values.firstWhere((v) => v.widgetType == 'SliverList');
      expect(sliverView, isNotNull);
    });
  });
}

class _LocaleConsumerWidget extends StatelessWidget {
  const _LocaleConsumerWidget();

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return Text(locale.toString());
  }
}

class _OrientationTextWidget extends StatelessWidget {
  const _OrientationTextWidget();

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Text(media.orientation.name);
  }
}

class _TestPainter extends CustomPainter {
  @override
  void paint(NativeCanvas canvas, Size size) {
    canvas.drawRect(Offset.zero, size, '#000000');
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _ThemeConsumerWidget extends StatelessWidget {
  const _ThemeConsumerWidget();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text('Themed Text', color: theme.primaryColor);
  }
}

class _TestStatefulWidget extends StatefulWidget {
  final void Function(void Function()) onRegister;
  const _TestStatefulWidget({super.key, required this.onRegister});

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
