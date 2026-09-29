import '../core/element.dart';
import '../core/widget.dart';
import '../state/change_notifier.dart';
import 'widgets.dart';

typedef PageRequestListener<T> = void Function(int pageKey);

class PagingController<K, V> extends ChangeNotifier {
  final K firstPageKey;
  final List<V> itemList = [];
  K? nextPageKey;
  bool _isLoading = false;

  PagingController({required this.firstPageKey});

  bool get isLoading => _isLoading;

  void appendPage(List<V> newItems, K? nextKey) {
    itemList.addAll(newItems);
    nextPageKey = nextKey;
    _isLoading = false;
    notifyListeners();
  }

  void notifyPageRequest(int pageKey) {
    if (!_isLoading) {
      _isLoading = true;
    }
  }
}

class PagedListView<K, V> extends StatefulWidget {
  final PagingController<K, V> pagingController;
  final Widget Function(BuildContext context, V item, int index) itemBuilder;
  final double itemExtent;

  const PagedListView({
    super.key,
    required this.pagingController,
    required this.itemBuilder,
    this.itemExtent = 50.0,
  });

  @override
  State<PagedListView<K, V>> createState() => _PagedListViewState<K, V>();
}

class _PagedListViewState<K, V> extends State<PagedListView<K, V>> {
  @override
  void initState() {
    super.initState();
    widget.pagingController.addListener(_onPagingChanged);
  }

  void _onPagingChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.pagingController.removeListener(_onPagingChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.pagingController.itemList;
    return ListView.builder(
      itemCount: items.length,
      itemExtent: widget.itemExtent,
      itemBuilder: (ctx, index) {
        return widget.itemBuilder(ctx, items[index], index);
      },
    );
  }
}
