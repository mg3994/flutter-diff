import '../core/element.dart';
import '../core/widget.dart';
import '../state/change_notifier.dart';
import '../widgets/gestures.dart';
import '../widgets/widgets.dart';

class TabController extends ChangeNotifier {
  final int length;
  int _index;

  TabController({
    required this.length,
    int initialIndex = 0,
  }) : _index = initialIndex;

  int get index => _index;

  set index(int newIndex) {
    if (newIndex != _index && newIndex >= 0 && newIndex < length) {
      _index = newIndex;
      notifyListeners();
    }
  }
}

class TabBar extends StatelessWidget {
  final TabController controller;
  final List<Widget> tabs;

  const TabBar({
    super.key,
    required this.controller,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(tabs.length, (i) {
        final isSelected = controller.index == i;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              controller.index = i;
            },
            child: Container(
              backgroundColor: isSelected ? '#0066CC' : '#E0E0E0',
              child: Padding(
                padding: 10.0,
                child: Center(child: tabs[i]),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class BottomNavigationBarItem {
  final Widget icon;
  final String label;

  const BottomNavigationBarItem({
    required this.icon,
    required this.label,
  });
}

class BottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int index)? onTap;
  final List<BottomNavigationBarItem> items;

  const BottomNavigationBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(items.length, (i) {
        final item = items[i];
        final isSelected = currentIndex == i;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              onTap?.call(i);
            },
            child: Container(
              backgroundColor: isSelected ? '#DDEEFF' : '#FFFFFF',
              child: Padding(
                padding: 8.0,
                child: Column(
                  children: [
                    item.icon,
                    Text(item.label, fontSize: 12.0),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
