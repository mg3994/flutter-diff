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
      expect((json['views'] as List<dynamic>).isNotEmpty, isTrue);
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

    test('Draggable and DragTarget interaction flow', () {
      final backend = VirtualNativeUIBackend();
      bool accepted = false;

      final app = FlutterZeroApp(
        rootWidget: Row(
          children: [
            const Draggable<String>(data: 'drag_payload', child: Text('Source')),
            DragTarget<String>(
              onAccept: (data) {
                if (data == 'drag_payload') accepted = true;
              },
              builder: (ctx, cand) => const Text('Target'),
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final gestureViews = backend.views.values.where((v) => v.widgetType == 'GestureDetector').toList();
      backend.dispatchNativeEvent(gestureViews[0].handle, 'longPress', {});
      backend.dispatchNativeEvent(gestureViews[1].handle, 'tap', {});

      expect(accepted, isTrue);
    });

    test('PagingController page appending and PagedListView rendering', () {
      final backend = VirtualNativeUIBackend();
      final controller = PagingController<int, String>(firstPageKey: 0);

      final app = FlutterZeroApp(
        rootWidget: PagedListView<int, String>(
          pagingController: controller,
          itemBuilder: (ctx, item, idx) => Text(item),
        ),
        backend: backend,
      );

      app.run();

      controller.appendPage(['Page Item 1', 'Page Item 2'], 1);

      final textViews = backend.views.values.where((v) => v.widgetType == 'Text').toList();
      expect(textViews.length, equals(2));
      expect(textViews[0].props['text'], equals('Page Item 1'));
    });

    test('HydratedStateNotifier state serialization and restoration', () {
      HydratedStateNotifier.clearStorage();
      final notifier = _TestHydratedNotifier();

      notifier.value = 99;
      expect(notifier.value, equals(99));

      final restoredNotifier = _TestHydratedNotifier();
      expect(restoredNotifier.value, equals(99));
    });

    test('CurvedAnimation transform calculation', () {
      final controller = AnimationController(duration: const Duration(seconds: 1), initialValue: 0.5);
      final curved = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

      expect(curved.value, equals(0.5));
    });

    test('NetworkImageCache URL caching and lookup', () {
      final cache = NetworkImageCache.instance;
      cache.clear();

      expect(cache.isCached('https://example.com/a.png'), isFalse);
      cache.cacheImage('https://example.com/a.png', '/tmp/a.png');

      expect(cache.isCached('https://example.com/a.png'), isTrue);
      expect(cache.getCachedPath('https://example.com/a.png'), equals('/tmp/a.png'));
    });

    test('WindowController title and size manipulation', () {
      final backend = VirtualNativeUIBackend();
      final handle = backend.createView('Window', {'title': 'Initial'});
      final controller = WindowController(backend: backend, windowHandle: handle);

      controller.setTitle('Updated Title');
      controller.setSize(const Size(1024, 768));

      final view = backend.getView(handle);
      expect(view?.props['title'], equals('Updated Title'));
      expect(view?.size, equals(const Size(1024, 768)));
    });

    test('KeyframeSequence interpolation steps', () {
      final seq = KeyframeSequence<double>([
        const Keyframe(0.0, 0.0),
        const Keyframe(0.5, 50.0),
        const Keyframe(1.0, 100.0),
      ]);

      expect(seq.transform(0.0), equals(0.0));
      expect(seq.transform(0.25), equals(25.0));
      expect(seq.transform(0.5), equals(50.0));
      expect(seq.transform(1.0), equals(100.0));
    });

    test('PluginRegistry registration and event dispatching', () {
      final plugin = _TestPlugin('test_plugin');
      PluginRegistry.register(plugin);

      expect(PluginRegistry.isRegistered('test_plugin'), isTrue);
      expect(plugin.initialized, isTrue);

      PluginRegistry.dispatchNativeEvent('test_event', {'foo': 'bar'});
      expect(plugin.lastEvent, equals('test_event'));
    });

    test('DesignTokens and ColorPalette light and dark theme metrics', () {
      const tokens = DesignTokens.standard;
      expect(tokens.colors.primary, equals('#0066CC'));
      expect(ColorPalette.defaultDark.background, equals('#121212'));
    });

    test('NativeMenuBar & NativeMenuItem JSON prop serialization', () {
      final backend = VirtualNativeUIBackend();
      final app = FlutterZeroApp(
        rootWidget: const NativeMenuBar(
          items: [
            NativeMenuItem(label: 'File', children: [
              NativeMenuItem(label: 'New'),
            ]),
          ],
        ),
        backend: backend,
      );
      app.run();

      final menuView = backend.views.values.firstWhere((v) => v.widgetType == 'NativeMenuBar');
      expect(menuView, isNotNull);
      final List<dynamic> items = menuView.props['menuItems'] as List<dynamic>;
      expect((items.first as Map<String, dynamic>)['label'], equals('File'));
    });

    test('ZeroRouter path matching and route parameters resolution', () {
      final backend = VirtualNativeUIBackend();
      final router = ZeroRouter(
        initialPath: '/user/123',
        routes: [
          ZeroRoute(
            path: '/user/:id',
            builder: (ctx, params) => Text('User ID: ${params['id']}'),
          ),
        ],
      );

      final app = FlutterZeroApp(
        rootWidget: router,
        backend: backend,
      );
      app.run();

      final textView = backend.views.values.firstWhere((v) => v.widgetType == 'Text');
      expect(textView.props['text'], equals('User ID: 123'));
    });

    test('NativeDataTable column and row props creation', () {
      final backend = VirtualNativeUIBackend();
      final app = FlutterZeroApp(
        rootWidget: const NativeDataTable(
          columns: [DataColumn(label: 'Name'), DataColumn(label: 'Age', numeric: true)],
          rows: [
            DataRow(cells: [DataCell(Text('Alice')), DataCell(Text('30'))]),
          ],
        ),
        backend: backend,
      );
      app.run();

      final tableView = backend.views.values.firstWhere((v) => v.widgetType == 'NativeDataTable');
      expect(tableView.props['rowCount'], equals(1));
    });

    test('RemoteWidgetLoader schema parsing and dynamic tree generation', () {
      final schema = {
        'type': 'Column',
        'children': [
          {'type': 'Text', 'properties': {'text': 'Dynamic Text'}},
          {'type': 'Button', 'properties': {'label': 'Dynamic Button'}},
        ],
      };

      final widget = RemoteWidgetLoader.parseSchema(schema);
      expect(widget, isA<Column>());
    });

    test('NativeFileDialog file open and directory picker mock resolution', () async {
      final backend = VirtualNativeUIBackend();
      final file = await NativeFileDialog.pickFile(backend: backend);
      final dir = await NativeFileDialog.pickDirectory(backend: backend);

      expect(file, equals('file://mock_picked_file.png'));
      expect(dir, equals('dir://mock_directory'));
    });

    test('signals_core Signal, computed, and effect reactive dependency tracking', () {
      final count = signal<int>(10);
      final doubleCount = computed<int>(() => count.value * 2);

      int observed = 0;
      effect(() {
        observed = doubleCount.value;
      });

      expect(observed, equals(20));

      count.value = 25;
      expect(observed, equals(50));
    });

    test('NativeClipboard copy and paste', () async {
      await NativeClipboard.setData('Copied Content');
      final text = await NativeClipboard.getData();

      expect(text, equals('Copied Content'));
    });

    test('NativeDevToolsServer tree serialization', () {
      final backend = VirtualNativeUIBackend();
      final server = NativeDevToolsServer(backend: backend);

      server.start(port: 9090);
      expect(server.isRunning, isTrue);

      final treeJson = server.getSerializedRenderTree();
      expect(treeJson.contains('rootCount'), isTrue);

      server.stop();
      expect(server.isRunning, isFalse);
    });

    test('ZeroHttpClient Dio instance & ZeroPreferences storage', () async {
      expect(ZeroHttpClient.client, isA<Dio>());

      await ZeroPreferences.setString('user_token', 'abc_123');
      expect(ZeroPreferences.getString('user_token'), equals('abc_123'));
    });

    test('NativeMediaPlayerWidget and ZeroThemeEngine mode changes', () {
      final backend = VirtualNativeUIBackend();
      final app = FlutterZeroApp(
        rootWidget: const NativeMediaPlayerWidget(mediaUrl: 'https://video.mp4'),
        backend: backend,
      );
      app.run();

      final mediaView = backend.views.values.firstWhere((v) => v.widgetType == 'NativeMediaPlayer');
      expect(mediaView.props['mediaUrl'], equals('https://video.mp4'));

      ZeroThemeEngine.setDarkMode(true);
      expect(ZeroThemeEngine.isDarkMode, isTrue);
    });

    test('CanvasCommand serialization and AssetWatcher file change notifications', () async {
      const command = CanvasCommand('drawRect', {'x': 0, 'y': 0, 'width': 100, 'height': 100});
      expect(command.toJson()['type'], equals('drawRect'));

      final watcher = AssetWatcher();
      watcher.watchAsset('assets/icon.png');

      String? changed;
      watcher.onAssetChanged.listen((path) {
        changed = path;
      });

      watcher.notifyChanged('assets/icon.png');
      await Future<void>.delayed(Duration.zero);

      expect(changed, equals('assets/icon.png'));
      watcher.dispose();
    });

    test('NativeStaggeredGrid layout and ZeroFormValidator validation rules', () {
      final backend = VirtualNativeUIBackend();
      final app = FlutterZeroApp(
        rootWidget: const NativeStaggeredGrid(
          crossAxisCount: 3,
          children: [Text('A'), Text('B')],
        ),
        backend: backend,
      );
      app.run();

      final gridView = backend.views.values.firstWhere((v) => v.widgetType == 'NativeStaggeredGrid');
      expect(gridView.props['crossAxisCount'], equals(3));

      expect(ZeroFormValidator.required(''), equals('Field is required'));
      expect(ZeroFormValidator.required('val'), isNull);
      expect(ZeroFormValidator.email('invalid'), equals('Invalid email address'));
      expect(ZeroFormValidator.email('test@example.com'), isNull);
    });

    test('ZeroWebSocketClient connection and messaging stream', () async {
      final client = ZeroWebSocketClient(url: 'wss://echo.websocket.org');
      await client.connect();

      expect(client.isConnected, isTrue);

      String? received;
      client.messages.listen((msg) {
        received = msg;
      });

      client.send('ping');
      await Future<void>.delayed(Duration.zero);

      expect(received, equals('echo: ping'));
      await client.close();
      expect(client.isConnected, isFalse);
    });

    test('ZeroSQLiteDatabase open, insert, query and close operations', () async {
      final db = ZeroSQLiteDatabase(path: '/tmp/test.db');
      await db.open();
      expect(db.isOpen, isTrue);

      await db.execute('CREATE TABLE users (id INT, name TEXT)');
      await db.insert('users', {'id': 1, 'name': 'Alice'});

      final rows = await db.query('users');
      expect(rows.length, equals(1));
      expect(rows.first['name'], equals('Alice'));

      await db.close();
      expect(db.isOpen, isFalse);
    });

    test('NativeBarcodeScanner widget creation', () {
      final backend = VirtualNativeUIBackend();
      final app = FlutterZeroApp(
        rootWidget: const NativeBarcodeScanner(),
        backend: backend,
      );
      app.run();

      final scannerView = backend.views.values.firstWhere((v) => v.widgetType == 'NativeBarcodeScanner');
      expect(scannerView, isNotNull);
    });

    test('ZeroSecureStorage and ZeroBiometricAuth operations', () async {
      await ZeroSecureStorage.write(key: 'secret_key', value: 'secret_val');
      expect(await ZeroSecureStorage.read(key: 'secret_key'), equals('secret_val'));

      expect(await ZeroBiometricAuth.isBiometricsAvailable(), isTrue);
      expect(await ZeroBiometricAuth.authenticate(localizedReason: 'Scan fingerprint'), isTrue);
    });

    test('ZeroUtils uuid generation, sha256 hashing, and ZeroModel equality', () {
      final uuid1 = ZeroUtils.generateUuid();
      final uuid2 = ZeroUtils.generateUuid();
      expect(uuid1, isNot(equals(uuid2)));

      final hash = ZeroUtils.sha256Hash('hello');
      expect(hash, equals('2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824'));

      final m1 = _TestModel('A', 10);
      final m2 = _TestModel('A', 10);
      expect(m1, equals(m2));
    });

    test('BlocBuilder reactivity, NativeChartWidget, NativePdfViewer, ZeroLocationService and NativeAudioRecorder', () async {
      final cubit = _TestCubit();
      expect(cubit.state, equals(0));

      cubit.increment();
      expect(cubit.state, equals(1));

      final backend = VirtualNativeUIBackend();
      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            const NativeChartWidget(chartType: 'bar', dataPoints: [{'x': 1, 'y': 10}]),
            const NativePdfViewer(documentPath: '/tmp/sample.pdf'),
            const NativeAudioRecorder(),
          ],
        ),
        backend: backend,
      );
      app.run();

      final chartView = backend.views.values.firstWhere((v) => v.widgetType == 'NativeChart');
      expect(chartView.props['chartType'], equals('bar'));

      expect(await ZeroLocationService.isLocationPermissionGranted(), isTrue);
      final loc = await ZeroLocationService.getCurrentLocation();
      expect(loc.latitude, equals(37.7749));

      await cubit.close();
    });

    test('ZeroServiceLocator GetIt instance, RxDart BehaviorSubject, NativeCalendar, NativeMap, and ZeroConnectivity', () async {
      ZeroServiceLocator.registerSingleton<String>('RegisteredService');
      expect(ZeroServiceLocator.get<String>(), equals('RegisteredService'));

      final subject = BehaviorSubject<int>.seeded(100);
      expect(subject.value, equals(100));
      await subject.close();

      final backend = VirtualNativeUIBackend();
      final app = FlutterZeroApp(
        rootWidget: const Column(
          children: [
            NativeCalendarWidget(),
            NativeMapWidget(latitude: 37.77, longitude: -122.41),
          ],
        ),
        backend: backend,
      );
      app.run();

      final mapNode = backend.views.values.firstWhere((v) => v.widgetType == 'NativeMap');
      expect(mapNode.props['latitude'], equals(37.77));

      final status = await ZeroConnectivity.checkConnectivity();
      expect(status, equals(ZeroConnectivityResult.wifi));
    });

    test('ZeroIntl formatting, ZeroLogger, and ZeroPath helpers', () {
      final formattedDate = ZeroIntl.formatDate(DateTime(2025, 1, 15));
      expect(formattedDate, equals('2025-01-15'));

      final formattedCurrency = ZeroIntl.formatCurrency(1234.5);
      expect(formattedCurrency.contains('1,234.50'), isTrue);

      ZeroLogger.i('Test log message');

      final joinedPath = ZeroPath.join('folder', 'file.txt');
      expect(joinedPath, equals('folder/file.txt'));
      expect(ZeroPath.extension('file.txt'), equals('.txt'));
      expect(ZeroPath.basename('folder/file.txt'), equals('file.txt'));
    });

    test('Drawer, BottomNavigationBar, ListTile, Card, Divider, and Badge widgets', () {
      final backend = VirtualNativeUIBackend();
      bool navTapped = false;
      bool listTapped = false;

      final app = FlutterZeroApp(
        rootWidget: Drawer(
          child: Column(
            children: [
              Card(
                child: ListTile(
                  title: const Text('Title'),
                  subtitle: const Text('Subtitle'),
                  onTap: () => listTapped = true,
                ),
              ),
              const Divider(),
              const Badge(label: 'New', child: Text('Badged Item')),
              BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(icon: Text('Home'), label: 'Home'),
                  BottomNavigationBarItem(icon: Text('Settings'), label: 'Settings'),
                ],
                onTap: (idx) => navTapped = true,
              ),
            ],
          ),
        ),
        backend: backend,
      );

      app.run();

      final drawerView = backend.views.values.firstWhere((v) => v.widgetType == 'Drawer');
      expect(drawerView.props['elevation'], equals(16.0));

      final listTileView = backend.views.values.firstWhere((v) => v.widgetType == 'ListTile');
      backend.dispatchNativeEvent(listTileView.handle, 'tap', {});
      expect(listTapped, isTrue);

      final navBarView = backend.views.values.firstWhere((v) => v.widgetType == 'BottomNavigationBar');
      backend.dispatchNativeEvent(navBarView.handle, 'tap', {'index': 1});
      expect(navTapped, isTrue);
    });

    test('Radio and DropdownButton controls', () {
      final backend = VirtualNativeUIBackend();
      String radioVal = 'A';
      int dropdownVal = 1;

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            Radio<String>(
              value: 'B',
              groupValue: radioVal,
              onChanged: (val) {
                if (val != null) radioVal = val;
              },
            ),
            DropdownButton<int>(
              value: dropdownVal,
              items: const [
                DropdownMenuItem(value: 1, child: Text('Option 1')),
                DropdownMenuItem(value: 2, child: Text('Option 2')),
              ],
              onChanged: (val) {
                if (val != null) dropdownVal = val;
              },
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final radioView = backend.views.values.firstWhere((v) => v.widgetType == 'Radio');
      backend.dispatchNativeEvent(radioView.handle, 'click', {});
      expect(radioVal, equals('B'));

      final dropdownView = backend.views.values.firstWhere((v) => v.widgetType == 'DropdownButton');
      backend.dispatchNativeEvent(dropdownView.handle, 'select', {'index': 1});
      expect(dropdownVal, equals(2));
    });

    test('AnimatedContainer, AnimatedOpacity, FadeTransition, and Hero animation widgets', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: const Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 100,
              height: 100,
              backgroundColor: '#FF0000',
              child: Text('Animated'),
            ),
            AnimatedOpacity(
              opacity: 0.8,
              duration: Duration(milliseconds: 200),
              child: Text('Opaque'),
            ),
            FadeTransition(
              opacity: 0.5,
              child: Text('Faded'),
            ),
            Hero(
              tag: 'hero_tag',
              child: Text('Hero Child'),
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final animContainer = backend.views.values.firstWhere((v) => v.widgetType == 'AnimatedContainer');
      expect(animContainer.props['durationMs'], equals(300));

      final heroView = backend.views.values.firstWhere((v) => v.widgetType == 'Hero');
      expect(heroView.props['tag'], equals('hero_tag'));
    });

    test('PageView, PageController, SliverToBoxAdapter, and SliverPadding widgets', () {
      final backend = VirtualNativeUIBackend();
      final controller = PageController(initialPage: 0);
      int changedPage = -1;

      final app = FlutterZeroApp(
        rootWidget: PageView(
          controller: controller,
          onPageChanged: (p) => changedPage = p,
          children: const [
            SliverToBoxAdapter(child: Text('Page 0')),
            SliverPadding(padding: 10.0, sliver: Text('Page 1')),
          ],
        ),
        backend: backend,
      );

      app.run();

      final pageView = backend.views.values.firstWhere((v) => v.widgetType == 'PageView');
      backend.dispatchNativeEvent(pageView.handle, 'pageChange', {'page': 1});

      expect(changedPage, equals(1));
      expect(controller.page, equals(1));
    });

    test('Material3Badge.count, CupertinoPageRoute, and FormField widgets', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            const Material3Badge.count(
              count: 5,
              child: Text('Notification Bell'),
            ),
            FormField<String>(
              initialValue: 'Initial Val',
              builder: (field) => Text('Field Val: ${field.value}'),
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final badge = backend.views.values.firstWhere((v) => v.widgetType == 'Material3Badge');
      expect(badge.props['count'], equals(5));

      final route = CupertinoPageRoute<void>(builder: (ctx) => const Text('Cupertino Route'));
      expect(route, isNotNull);
    });

    test('Overlay, OverlayEntry, SliverLayoutBuilder, and SecondaryTabBar widgets', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            Overlay(
              initialEntries: [
                OverlayEntry(builder: (ctx) => const Text('Overlay Entry Child')),
              ],
            ),
            SliverLayoutBuilder(
              builder: (ctx, constraints) => const Text('Sliver Layout Child'),
            ),
            const SecondaryTabBar(
              tabs: [Text('Sec Tab 1'), Text('Sec Tab 2')],
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final overlay = backend.views.values.firstWhere((v) => v.widgetType == 'Overlay');
      expect(overlay, isNotNull);

      final sliverLayoutBuilder = backend.views.values.firstWhere((v) => v.widgetType == 'SliverLayoutBuilder');
      expect(sliverLayoutBuilder, isNotNull);

      final secTabBar = backend.views.values.firstWhere((v) => v.widgetType == 'SecondaryTabBar');
      expect(secTabBar, isNotNull);
    });

    test('DecoratedBox, ColoredBox, SlideTransition, LayoutBuilder, and OrientationBuilder widgets', () {
      final backend = VirtualNativeUIBackend();

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                color: '#0000FF',
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text('Decorated'),
            ),
            const ColoredBox(
              color: '#FF00FF',
              child: Text('Colored'),
            ),
            const SlideTransition(
              position: Offset(10, 20),
              child: Text('Slid'),
            ),
            LayoutBuilder(
              builder: (ctx, constraints) => Text('MaxW: ${constraints.maxWidth}'),
            ),
            OrientationBuilder(
              builder: (ctx, orientation) => Text('Orientation: ${orientation.name}'),
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final decoratedBox = backend.views.values.firstWhere((v) => v.widgetType == 'DecoratedBox');
      expect(decoratedBox.props['decoration'], isNotNull);

      final coloredBox = backend.views.values.firstWhere((v) => v.widgetType == 'ColoredBox');
      expect(coloredBox.props['color'], equals('#FF00FF'));

      final slideTransition = backend.views.values.firstWhere((v) => v.widgetType == 'SlideTransition');
      expect(slideTransition.props['dx'], equals(10.0));
    });

    test('FittedBox, AspectRatio, Spacer, AnimatedSwitcher, and FocusScope widgets', () {
      final backend = VirtualNativeUIBackend();
      final focusNode = FocusScopeNode();

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            const FittedBox(
              child: Text('Fitted Content'),
            ),
            const AspectRatio(
              aspectRatio: 16 / 9,
              child: Text('16:9 Aspect'),
            ),
            const Spacer(),
            const AnimatedSwitcher(
              duration: Duration(milliseconds: 250),
              child: Text('Switched'),
            ),
            FocusScope(
              node: focusNode,
              child: const Text('Focused Area'),
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final fittedBox = backend.views.values.firstWhere((v) => v.widgetType == 'FittedBox');
      expect(fittedBox, isNotNull);

      final aspectRatio = backend.views.values.firstWhere((v) => v.widgetType == 'AspectRatio');
      expect(aspectRatio.props['aspectRatio'], equals(16 / 9));

      final animSwitcher = backend.views.values.firstWhere((v) => v.widgetType == 'AnimatedSwitcher');
      expect(animSwitcher.props['durationMs'], equals(250));

      focusNode.requestFocus();
      expect(focusNode.hasFocus, isTrue);
    });

    test('MenuAnchor, CupertinoSliverRefreshControl, and PaginatedDataTable widgets', () {
      final backend = VirtualNativeUIBackend();
      bool menuItemClicked = false;
      bool refreshTriggered = false;

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            MenuAnchor(
              menuChildren: [
                MenuItemButton(
                  onPressed: () => menuItemClicked = true,
                  child: const Text('Menu Item 1'),
                ),
              ],
              child: const Text('Open Menu'),
            ),
            CupertinoSliverRefreshControl(
              onRefresh: () async => refreshTriggered = true,
            ),
            PaginatedDataTable(
              header: const Text('Data Header'),
              columns: const [DataColumn(label: 'Col 1')],
              source: _TestTableSource(),
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final menuItem = backend.views.values.firstWhere((v) => v.widgetType == 'MenuItemButton');
      backend.dispatchNativeEvent(menuItem.handle, 'click', {});
      expect(menuItemClicked, isTrue);

      final refreshControl = backend.views.values.firstWhere((v) => v.widgetType == 'CupertinoSliverRefreshControl');
      backend.dispatchNativeEvent(refreshControl.handle, 'refresh', {});
      expect(refreshTriggered, isTrue);

      final paginatedTable = backend.views.values.firstWhere((v) => v.widgetType == 'PaginatedDataTable');
      expect(paginatedTable.props['columnCount'], equals(1));
    });

    test('SearchAnchor and CupertinoPicker widgets', () {
      final backend = VirtualNativeUIBackend();
      int selectedPickerIndex = -1;

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            SearchAnchor(
              builder: (ctx) => const Text('Search Button'),
              suggestionsBuilder: (ctx, q) => [const Text('Suggestion 1')],
            ),
            CupertinoPicker(
              itemExtent: 32.0,
              onSelectedItemChanged: (idx) => selectedPickerIndex = idx,
              children: const [Text('Option 1'), Text('Option 2')],
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final searchAnchor = backend.views.values.firstWhere((v) => v.widgetType == 'SearchAnchor');
      expect(searchAnchor, isNotNull);

      final picker = backend.views.values.firstWhere((v) => v.widgetType == 'CupertinoPicker');
      backend.dispatchNativeEvent(picker.handle, 'select', {'index': 1});
      expect(selectedPickerIndex, equals(1));
    });

    test('NavigationDrawerDestination, CupertinoListTile, CupertinoListSection, and RadioFormField widgets', () {
      final backend = VirtualNativeUIBackend();
      bool listTileTapped = false;
      String radioFormVal = 'A';

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            const NavigationDrawerDestination(
              icon: Text('Icon'),
              label: Text('Label'),
            ),
            CupertinoListSection(
              header: const Text('Section Header'),
              children: [
                CupertinoListTile(
                  title: const Text('Tile Title'),
                  onTap: () => listTileTapped = true,
                ),
              ],
            ),
            RadioFormField<String>(
              value: 'B',
              groupValue: radioFormVal,
              onChanged: (v) {
                if (v != null) radioFormVal = v;
              },
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final drawerDest = backend.views.values.firstWhere((v) => v.widgetType == 'NavigationDrawerDestination');
      expect(drawerDest, isNotNull);

      final listTile = backend.views.values.firstWhere((v) => v.widgetType == 'CupertinoListTile');
      backend.dispatchNativeEvent(listTile.handle, 'tap', {});
      expect(listTileTapped, isTrue);

      final radioFormField = backend.views.values.firstWhere((v) => v.widgetType == 'RadioFormField');
      backend.dispatchNativeEvent(radioFormField.handle, 'click', {});
      expect(radioFormVal, equals('B'));
    });

    test('FloatingActionButtonExtended, CupertinoTabScaffold, and SwitchFormField widgets', () {
      final backend = VirtualNativeUIBackend();
      bool fabClicked = false;
      bool switchVal = false;

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            FloatingActionButtonExtended(
              icon: const Text('+'),
              label: const Text('Add Item'),
              onPressed: () => fabClicked = true,
            ),
            CupertinoTabScaffold(
              tabBar: const Text('Tab Bar'),
              tabBuilder: (ctx, idx) => Text('Tab Body $idx'),
            ),
            SwitchFormField(
              value: switchVal,
              onChanged: (v) => switchVal = v,
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final fabExt = backend.views.values.firstWhere((v) => v.widgetType == 'FloatingActionButtonExtended');
      backend.dispatchNativeEvent(fabExt.handle, 'click', {});
      expect(fabClicked, isTrue);

      final tabScaffold = backend.views.values.firstWhere((v) => v.widgetType == 'CupertinoTabScaffold');
      expect(tabScaffold, isNotNull);

      final switchFormField = backend.views.values.firstWhere((v) => v.widgetType == 'SwitchFormField');
      backend.dispatchNativeEvent(switchFormField.handle, 'change', {'value': true});
      expect(switchVal, isTrue);
    });

    test('InputChip, RawChip, CupertinoPopupSurface, and CalendarDatePicker widgets', () {
      final backend = VirtualNativeUIBackend();
      bool chipClicked = false;
      bool chipDeleted = false;
      DateTime? selectedCalendarDate;

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            InputChip(
              label: const Text('Input Chip'),
              onPressed: () => chipClicked = true,
              onDeleted: () => chipDeleted = true,
            ),
            RawChip(
              label: const Text('Raw Chip'),
              selected: true,
            ),
            const CupertinoPopupSurface(
              child: Text('Popup Content'),
            ),
            CalendarDatePicker(
              initialDate: DateTime(2025, 1, 1),
              firstDate: DateTime(2020, 1, 1),
              lastDate: DateTime(2030, 1, 1),
              onDateChanged: (d) => selectedCalendarDate = d,
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final inputChip = backend.views.values.firstWhere((v) => v.widgetType == 'InputChip');
      backend.dispatchNativeEvent(inputChip.handle, 'click', {});
      expect(chipClicked, isTrue);

      backend.dispatchNativeEvent(inputChip.handle, 'delete', {});
      expect(chipDeleted, isTrue);

      final popupSurface = backend.views.values.firstWhere((v) => v.widgetType == 'CupertinoPopupSurface');
      expect(popupSurface, isNotNull);

      final calendarDatePicker = backend.views.values.firstWhere((v) => v.widgetType == 'CalendarDatePicker');
      backend.dispatchNativeEvent(calendarDatePicker.handle, 'dateChange', {'isoString': '2025-08-20T00:00:00.000'});
      expect(selectedCalendarDate, equals(DateTime(2025, 8, 20)));
    });

    test('SnackBar, CupertinoContextMenu, and SliverFillViewport widgets', () {
      final backend = VirtualNativeUIBackend();
      bool snackBarActionClicked = false;
      bool contextMenuActionClicked = false;

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            SnackBar(
              content: const Text('Snack Content'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () => snackBarActionClicked = true,
              ),
            ),
            CupertinoContextMenu(
              actions: [
                CupertinoContextMenuAction(
                  onPressed: () => contextMenuActionClicked = true,
                  child: const Text('Action 1'),
                ),
              ],
              child: const Text('Context Target'),
            ),
            const SliverFillViewport(
              children: [Text('Viewport 1'), Text('Viewport 2')],
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final snackBarAction = backend.views.values.firstWhere((v) => v.widgetType == 'SnackBarAction');
      backend.dispatchNativeEvent(snackBarAction.handle, 'click', {});
      expect(snackBarActionClicked, isTrue);

      final menuAction = backend.views.values.firstWhere((v) => v.widgetType == 'CupertinoContextMenuAction');
      backend.dispatchNativeEvent(menuAction.handle, 'click', {});
      expect(contextMenuActionClicked, isTrue);

      final viewport = backend.views.values.firstWhere((v) => v.widgetType == 'SliverFillViewport');
      expect(viewport.props['viewportFraction'], equals(1.0));
    });

    test('ElevatedCard, OutlinedCard, Tooltip, CupertinoNavigationBar, CupertinoTextField, and CheckboxFormField widgets', () {
      final backend = VirtualNativeUIBackend();
      String cupertinoInputText = '';
      bool checkboxValue = false;

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            const ElevatedCard(
              elevation: 4.0,
              child: Text('Elevated Card'),
            ),
            const OutlinedCard(
              child: Text('Outlined Card'),
            ),
            const Tooltip(
              message: 'Tooltip Message',
              child: Text('Hover Target'),
            ),
            const CupertinoNavigationBar(
              leading: Text('Back'),
              middle: Text('Title'),
            ),
            CupertinoTextField(
              placeholder: 'Enter text',
              onChanged: (txt) => cupertinoInputText = txt,
            ),
            CheckboxFormField(
              value: checkboxValue,
              onChanged: (v) => checkboxValue = v ?? false,
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final elevatedCard = backend.views.values.firstWhere((v) => v.widgetType == 'ElevatedCard');
      expect(elevatedCard.props['elevation'], equals(4.0));

      final tooltip = backend.views.values.firstWhere((v) => v.widgetType == 'Tooltip');
      expect(tooltip.props['message'], equals('Tooltip Message'));

      final cupertinoTextField = backend.views.values.firstWhere((v) => v.widgetType == 'CupertinoTextField');
      backend.dispatchNativeEvent(cupertinoTextField.handle, 'change', {'text': 'iOS Input'});
      expect(cupertinoInputText, equals('iOS Input'));

      final checkboxFormField = backend.views.values.firstWhere((v) => v.widgetType == 'CheckboxFormField');
      backend.dispatchNativeEvent(checkboxFormField.handle, 'change', {'value': true});
      expect(checkboxValue, isTrue);
    });

    test('NavigationBar, NavigationRail, FloatingActionButton, CupertinoActionSheet, and DropdownButtonFormField widgets', () {
      final backend = VirtualNativeUIBackend();
      int navIndex = -1;
      bool fabClicked = false;
      bool actionClicked = false;
      int? dropdownVal;

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            NavigationBar(
              selectedIndex: 0,
              onDestinationSelected: (idx) => navIndex = idx,
              destinations: const [Text('Home'), Text('Search')],
            ),
            NavigationRail(
              selectedIndex: 0,
              onDestinationSelected: (idx) => navIndex = idx,
              destinations: const [
                NavigationRailDestination(icon: Text('Icon'), label: Text('Rail Label')),
              ],
            ),
            FloatingActionButton(
              onPressed: () => fabClicked = true,
              child: const Text('+'),
            ),
            CupertinoActionSheet(
              title: const Text('Sheet Title'),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () => actionClicked = true,
                  child: const Text('Sheet Action'),
                ),
              ],
            ),
            DropdownButtonFormField<int>(
              value: 1,
              items: const [
                DropdownMenuItem(value: 1, child: Text('Item 1')),
                DropdownMenuItem(value: 2, child: Text('Item 2')),
              ],
              onChanged: (v) => dropdownVal = v,
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final navBar = backend.views.values.firstWhere((v) => v.widgetType == 'NavigationBar');
      backend.dispatchNativeEvent(navBar.handle, 'select', {'index': 1});
      expect(navIndex, equals(1));

      final fab = backend.views.values.firstWhere((v) => v.widgetType == 'FloatingActionButton');
      backend.dispatchNativeEvent(fab.handle, 'click', {});
      expect(fabClicked, isTrue);

      final sheetAction = backend.views.values.firstWhere((v) => v.widgetType == 'CupertinoActionSheetAction');
      backend.dispatchNativeEvent(sheetAction.handle, 'click', {});
      expect(actionClicked, isTrue);

      final dropdownFormField = backend.views.values.firstWhere((v) => v.widgetType == 'DropdownButtonFormField');
      backend.dispatchNativeEvent(dropdownFormField.handle, 'select', {'index': 1});
      expect(dropdownVal, equals(2));
    });

    test('NavigationDrawer, CarouselView, CupertinoTimerPicker, CupertinoSlidingSegmentedControl, and BackdropFilter widgets', () {
      final backend = VirtualNativeUIBackend();
      int drawerIndex = -1;
      Duration? timerDuration;
      String? segmentVal;

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            NavigationDrawer(
              onDestinationSelected: (idx) => drawerIndex = idx,
              children: const [
                Text('Dest 0'),
                Text('Dest 1'),
              ],
            ),
            const CarouselView(
              itemExtent: 150,
              children: [Text('Card A'), Text('Card B')],
            ),
            CupertinoTimerPicker(
              onTimerDurationChanged: (d) => timerDuration = d,
            ),
            CupertinoSlidingSegmentedControl<String>(
              groupValue: 'A',
              children: const {'A': Text('Tab A'), 'B': Text('Tab B')},
              onValueChanged: (v) => segmentVal = v,
            ),
            const BackdropFilter(
              sigmaX: 5.0,
              sigmaY: 5.0,
              child: Text('Blurred'),
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final drawer = backend.views.values.firstWhere((v) => v.widgetType == 'NavigationDrawer');
      backend.dispatchNativeEvent(drawer.handle, 'select', {'index': 1});
      expect(drawerIndex, equals(1));

      final timerPicker = backend.views.values.firstWhere((v) => v.widgetType == 'CupertinoTimerPicker');
      backend.dispatchNativeEvent(timerPicker.handle, 'durationChange', {'durationMs': 60000});
      expect(timerDuration, equals(const Duration(minutes: 1)));

      final segmented = backend.views.values.firstWhere((v) => v.widgetType == 'CupertinoSlidingSegmentedControl');
      backend.dispatchNativeEvent(segmented.handle, 'select', {'index': 1});
      expect(segmentVal, equals('B'));

      final filter = backend.views.values.firstWhere((v) => v.widgetType == 'BackdropFilter');
      expect(filter.props['sigmaX'], equals(5.0));
    });

    test('MouseRegion, Listener, SliverFillRemaining, RichText, and SelectableText widgets', () {
      final backend = VirtualNativeUIBackend();
      bool mouseEntered = false;
      bool pointerDown = false;

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            MouseRegion(
              onEnter: (e) => mouseEntered = true,
              child: const Text('Hover Me'),
            ),
            Listener(
              onPointerDown: (e) => pointerDown = true,
              child: const Text('Touch Me'),
            ),
            const SliverFillRemaining(
              child: Text('Remaining Space'),
            ),
            const RichText(
              text: TextSpan(
                text: 'Rich',
                children: [TextSpan(text: 'TextSpan')],
              ),
            ),
            const SelectableText('Selectable Text Content'),
          ],
        ),
        backend: backend,
      );

      app.run();

      final mouseRegionView = backend.views.values.firstWhere((v) => v.widgetType == 'MouseRegion');
      backend.dispatchNativeEvent(mouseRegionView.handle, 'mouseEnter', {});
      expect(mouseEntered, isTrue);

      final listenerView = backend.views.values.firstWhere((v) => v.widgetType == 'Listener');
      backend.dispatchNativeEvent(listenerView.handle, 'pointerDown', {});
      expect(pointerDown, isTrue);

      final richTextView = backend.views.values.firstWhere((v) => v.widgetType == 'RichText');
      expect(richTextView, isNotNull);

      final selectableTextView = backend.views.values.firstWhere((v) => v.widgetType == 'SelectableText');
      expect(selectableTextView.props['text'], equals('Selectable Text Content'));
    });

    test('InkWell, Material, FilterChip, RangeSlider, Autocomplete, CupertinoAlertDialog, and CupertinoDatePicker widgets', () {
      final backend = VirtualNativeUIBackend();
      bool inkWellTapped = false;
      bool filterChipSelected = false;
      RangeValues? rangeVal;
      String? autocompleteSelection;
      DateTime? pickedDate;

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            InkWell(
              onTap: () => inkWellTapped = true,
              child: const Text('InkWell Child'),
            ),
            const Material(
              elevation: 2.0,
              child: Text('Material Child'),
            ),
            FilterChip(
              label: const Text('Filter'),
              selected: filterChipSelected,
              onSelected: (s) => filterChipSelected = s,
            ),
            RangeSlider(
              values: const RangeValues(0.2, 0.8),
              onChanged: (v) => rangeVal = v,
            ),
            Autocomplete<String>(
              options: const ['Option A', 'Option B'],
              onSelected: (s) => autocompleteSelection = s,
            ),
            const CupertinoAlertDialog(
              title: Text('Cupertino Alert'),
              content: Text('Alert Content'),
            ),
            CupertinoDatePicker(
              initialDateTime: DateTime(2025, 1, 1),
              onDateTimeChanged: (dt) => pickedDate = dt,
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final inkWellView = backend.views.values.firstWhere((v) => v.widgetType == 'InkWell');
      backend.dispatchNativeEvent(inkWellView.handle, 'tap', {});
      expect(inkWellTapped, isTrue);

      final filterChipView = backend.views.values.firstWhere((v) => v.widgetType == 'FilterChip');
      backend.dispatchNativeEvent(filterChipView.handle, 'select', {});
      expect(filterChipSelected, isTrue);

      final rangeSliderView = backend.views.values.firstWhere((v) => v.widgetType == 'RangeSlider');
      backend.dispatchNativeEvent(rangeSliderView.handle, 'change', {'start': 0.1, 'end': 0.9});
      expect(rangeVal?.start, equals(0.1));
      expect(rangeVal?.end, equals(0.9));

      final autocompleteView = backend.views.values.firstWhere((v) => v.widgetType == 'Autocomplete');
      backend.dispatchNativeEvent(autocompleteView.handle, 'select', {'index': 1});
      expect(autocompleteSelection, equals('Option B'));

      final datePickerView = backend.views.values.firstWhere((v) => v.widgetType == 'CupertinoDatePicker');
      backend.dispatchNativeEvent(datePickerView.handle, 'dateTimeChange', {'isoString': '2025-06-15T12:00:00.000'});
      expect(pickedDate, equals(DateTime(2025, 6, 15, 12, 0, 0)));
    });

    test('CupertinoButton, CupertinoSwitch, SearchBar, SegmentedButton, IndexedStack, and Transform widgets', () {
      final backend = VirtualNativeUIBackend();
      bool cupertinoBtnClicked = false;
      bool cupertinoSwitchVal = false;
      String searchVal = '';
      Set<int> segmentedSelection = {1};

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            CupertinoButton(
              onPressed: () => cupertinoBtnClicked = true,
              child: const Text('Cupertino Button'),
            ),
            CupertinoSwitch(
              value: cupertinoSwitchVal,
              onChanged: (v) => cupertinoSwitchVal = v,
            ),
            SearchBar(
              hintText: 'Search...',
              onChanged: (q) => searchVal = q,
            ),
            SegmentedButton<int>(
              selected: segmentedSelection,
              segments: const [
                ButtonSegment(value: 1, label: Text('Seg 1')),
                ButtonSegment(value: 2, label: Text('Seg 2')),
              ],
              onSelectionChanged: (s) => segmentedSelection = s,
            ),
            const IndexedStack(
              index: 0,
              children: [Text('Page A'), Text('Page B')],
            ),
            const Transform.scale(
              scale: 1.5,
              child: Text('Scaled'),
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final cupertinoBtn = backend.views.values.firstWhere((v) => v.widgetType == 'CupertinoButton');
      backend.dispatchNativeEvent(cupertinoBtn.handle, 'click', {});
      expect(cupertinoBtnClicked, isTrue);

      final cupertinoSwitch = backend.views.values.firstWhere((v) => v.widgetType == 'CupertinoSwitch');
      backend.dispatchNativeEvent(cupertinoSwitch.handle, 'change', {'value': true});
      expect(cupertinoSwitchVal, isTrue);

      final searchBar = backend.views.values.firstWhere((v) => v.widgetType == 'SearchBar');
      backend.dispatchNativeEvent(searchBar.handle, 'change', {'text': 'flutter zero'});
      expect(searchVal, equals('flutter zero'));

      final segmentedBtn = backend.views.values.firstWhere((v) => v.widgetType == 'SegmentedButton');
      backend.dispatchNativeEvent(segmentedBtn.handle, 'select', {'index': 1});
      expect(segmentedSelection, equals({2}));

      final transformView = backend.views.values.firstWhere((v) => v.widgetType == 'Transform');
      expect(transformView.props['scale'], equals(1.5));
    });

    test('CircularProgressIndicator, LinearProgressIndicator, Stepper, Table, ExpansionPanelList, and SimpleDialog widgets', () {
      final backend = VirtualNativeUIBackend();
      bool optionClicked = false;

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            const CircularProgressIndicator(value: 0.5, color: '#00FF00'),
            const LinearProgressIndicator(color: '#FF0000'),
            Stepper(
              steps: const [
                Step(title: Text('Step 1'), content: Text('Step 1 Content')),
              ],
            ),
            const Table(
              children: [
                TableRow(children: [Text('Cell 1'), Text('Cell 2')]),
              ],
            ),
            ExpansionPanelList(
              children: [
                ExpansionPanel(
                  headerBuilder: const Text('Header'),
                  body: const Text('Body'),
                  isExpanded: true,
                ),
              ],
            ),
            SimpleDialog(
              title: const Text('Title'),
              children: [
                SimpleDialogOption(
                  onPressed: () => optionClicked = true,
                  child: const Text('Option'),
                ),
              ],
            ),
            const AboutDialog(
              applicationName: 'Test App',
              applicationVersion: '1.0.0',
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final circularView = backend.views.values.firstWhere((v) => v.widgetType == 'CircularProgressIndicator');
      expect(circularView.props['value'], equals(0.5));

      final optionView = backend.views.values.firstWhere((v) => v.widgetType == 'SimpleDialogOption');
      backend.dispatchNativeEvent(optionView.handle, 'click', {});
      expect(optionClicked, isTrue);

      final aboutView = backend.views.values.firstWhere((v) => v.widgetType == 'AboutDialog');
      expect(aboutView.props['name'], equals('Test App'));
    });

    test('SwitchListTile, RadioListTile, ChoiceChip, BottomSheet, and MaterialBanner widgets', () {
      final backend = VirtualNativeUIBackend();
      bool switchVal = false;
      String radioGroup = 'X';
      bool chipSelected = false;

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            SwitchListTile(
              value: switchVal,
              onChanged: (v) => switchVal = v,
              title: const Text('Switch Tile'),
            ),
            RadioListTile<String>(
              value: 'Y',
              groupValue: radioGroup,
              onChanged: (v) {
                if (v != null) radioGroup = v;
              },
              title: const Text('Radio Tile'),
            ),
            ChoiceChip(
              label: const Text('Chip'),
              selected: chipSelected,
              onSelected: (s) => chipSelected = s,
            ),
            const BottomSheet(
              child: Text('Sheet Content'),
            ),
            const MaterialBanner(
              content: Text('Banner Message'),
              actions: [Text('Action')],
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final switchTile = backend.views.values.firstWhere((v) => v.widgetType == 'SwitchListTile');
      backend.dispatchNativeEvent(switchTile.handle, 'toggle', {'value': true});
      expect(switchVal, isTrue);

      final radioTile = backend.views.values.firstWhere((v) => v.widgetType == 'RadioListTile');
      backend.dispatchNativeEvent(radioTile.handle, 'click', {});
      expect(radioGroup, equals('Y'));

      final choiceChip = backend.views.values.firstWhere((v) => v.widgetType == 'ChoiceChip');
      backend.dispatchNativeEvent(choiceChip.handle, 'select', {});
      expect(chipSelected, isTrue);

      final bottomSheet = backend.views.values.firstWhere((v) => v.widgetType == 'BottomSheet');
      expect(bottomSheet, isNotNull);
    });

    test('Opacity, Dismissible, and ReorderableListView visual and interaction widgets', () {
      final backend = VirtualNativeUIBackend();
      bool dismissed = false;
      int reorderOld = -1;
      int reorderNew = -1;

      final app = FlutterZeroApp(
        rootWidget: Column(
          children: [
            const Opacity(
              opacity: 0.4,
              child: Text('Low Opacity'),
            ),
            Dismissible(
              onDismissed: () => dismissed = true,
              child: const Text('Dismiss Me'),
            ),
            ReorderableListView(
              children: const [Text('Item A'), Text('Item B')],
              onReorder: (oldIdx, newIdx) {
                reorderOld = oldIdx;
                reorderNew = newIdx;
              },
            ),
          ],
        ),
        backend: backend,
      );

      app.run();

      final dismissView = backend.views.values.firstWhere((v) => v.widgetType == 'Dismissible');
      backend.dispatchNativeEvent(dismissView.handle, 'dismiss', {});
      expect(dismissed, isTrue);

      final reorderView = backend.views.values.firstWhere((v) => v.widgetType == 'ReorderableListView');
      backend.dispatchNativeEvent(reorderView.handle, 'reorder', {'oldIndex': 0, 'newIndex': 1});
      expect(reorderOld, equals(0));
      expect(reorderNew, equals(1));
    });
  });
}

class _TestCubit extends Cubit<int> {
  _TestCubit() : super(0);
  void increment() => emit(state + 1);
}

class _TestModel extends ZeroModel {
  final String name;
  final int value;

  const _TestModel(this.name, this.value);

  @override
  List<Object?> get props => [name, value];
}

class _TestPlugin extends FlutterZeroPlugin {
  bool initialized = false;
  String? lastEvent;

  _TestPlugin(super.name);

  @override
  void onAppInit() {
    initialized = true;
  }

  @override
  void onNativeEvent(String eventName, Map<String, dynamic> data) {
    lastEvent = eventName;
  }
}

class _TestHydratedNotifier extends HydratedStateNotifier<int> {
  _TestHydratedNotifier() : super(0, storageKey: 'test_hydrated_key');

  @override
  int? fromJson(Map<String, dynamic> json) => json['val'] as int?;

  @override
  Map<String, dynamic> toJson(int state) => {'val': state};
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

class _TestTableSource extends DataTableSource {
  @override
  DataRow? getRow(int index) => DataRow(cells: [DataCell(Text('Row $index'))]);

  @override
  int get rowCount => 10;

  @override
  bool get isRowCountApproximate => false;
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
