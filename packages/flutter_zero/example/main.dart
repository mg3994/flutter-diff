import 'package:flutter_zero/flutter_zero.dart';

class CounterNotifier extends HydratedStateNotifier<int> {
  CounterNotifier() : super(0, storageKey: 'app_counter');

  @override
  int? fromJson(Map<String, dynamic> json) => json['val'] as int?;

  @override
  Map<String, dynamic> toJson(int state) => {'val': state};
}

void main() {
  print('=== Initializing Flutter Zero App with Draggable, Pagination & Hydrated State ===\n');

  final backend = VirtualNativeUIBackend();
  final counterNotifier = CounterNotifier();

  final pagingController = PagingController<int, String>(firstPageKey: 0);
  pagingController.appendPage(['Page 1 Item A', 'Page 1 Item B'], 1);

  final app = FlutterZeroApp(
    rootWidget: Container(
      backgroundColor: '#FAFAFA',
      child: Padding(
        padding: 20.0,
        child: Column(
          children: [
            const Text(
              'Flutter Zero Drag & Drop, Pagination & Hydrated Notifier',
              fontSize: 18.0,
              color: '#222222',
            ),
            const SizedBox(height: 15.0),
            ValueListenableBuilder<int>(
              valueListenable: counterNotifier,
              builder: (ctx, count, child) => Text('Hydrated Persistent Counter: $count'),
            ),
            const SizedBox(height: 15.0),
            Row(
              children: [
                Draggable<String>(
                  data: 'Draggable Native Data',
                  child: Container(
                    backgroundColor: '#E0E0E0',
                    child: const Padding(
                      padding: 8.0,
                      child: Text('Drag Me Source'),
                    ),
                  ),
                ),
                const SizedBox(width: 15.0),
                DragTarget<String>(
                  onAccept: (data) {
                    print('Accepted drag data: $data');
                  },
                  builder: (ctx, candidate) {
                    return Container(
                      backgroundColor: candidate != null ? '#DDEEFF' : '#EEEEEE',
                      child: const Padding(
                        padding: 8.0,
                        child: Text('Drop Target Zone'),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Expanded(
              child: PagedListView<int, String>(
                pagingController: pagingController,
                itemExtent: 35.0,
                itemBuilder: (ctx, item, index) => Text(item),
              ),
            ),
          ],
        ),
      ),
    ),
    backend: backend,
  );

  app.run();

  counterNotifier.value = 42;

  print('=== Native View Hierarchy ===');
  print(backend.printTree());
}
