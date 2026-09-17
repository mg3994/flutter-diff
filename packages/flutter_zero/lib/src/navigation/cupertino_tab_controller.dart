import '../core/change_notifier.dart';

class CupertinoTabController extends ChangeNotifier {
  int _index;

  CupertinoTabController({int initialIndex = 0}) : _index = initialIndex;

  int get index => _index;

  set index(int value) {
    if (_index != value) {
      _index = value;
      notifyListeners();
    }
  }
}
