import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import '../navigation/dialog.dart';
import 'gestures.dart';
import 'widgets.dart';

class Tooltip extends NativeRenderWidget {
  final String message;
  final Widget child;

  const Tooltip({
    super.key,
    required this.message,
    required this.child,
  });

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'Tooltip',
      props: {'message': message},
    );
  }
}

class PopupMenuItem<T> {
  final T value;
  final Widget child;

  const PopupMenuItem({
    required this.value,
    required this.child,
  });
}

class PopupMenuButton<T> extends StatelessWidget {
  final List<PopupMenuItem<T>> items;
  final void Function(T selectedValue)? onSelected;
  final Widget? icon;

  const PopupMenuButton({
    super.key,
    required this.items,
    this.onSelected,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (dialogCtx) => Container(
            backgroundColor: '#FFFFFF',
            child: Padding(
              padding: 10.0,
              child: Column(
                children: items.map((item) {
                  return GestureDetector(
                    onTap: () {
                      onSelected?.call(item.value);
                    },
                    child: Padding(
                      padding: 8.0,
                      child: item.child,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
      child: icon ?? const Text('Menu'),
    );
  }
}
