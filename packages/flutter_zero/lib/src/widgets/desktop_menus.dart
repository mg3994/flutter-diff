import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

/// Represents a menu item in a native top-level menu bar or context menu.
class NativeMenuItem {
  final String label;
  final String? shortcutKey;
  final void Function()? onPressed;
  final bool isEnabled;
  final List<NativeMenuItem>? children;

  const NativeMenuItem({
    required this.label,
    this.shortcutKey,
    this.onPressed,
    this.isEnabled = true,
    this.children,
  });

  Map<String, dynamic> toJson() => {
        'label': label,
        'shortcutKey': shortcutKey,
        'enabled': isEnabled,
        'children': children?.map((c) => c.toJson()).toList(),
      };
}

/// A native menu bar widget that binds system top-level menu bars (macOS / Windows / Linux).
class NativeMenuBar extends NativeRenderWidget {
  final List<NativeMenuItem> items;
  final Widget? child;

  const NativeMenuBar({
    super.key,
    required this.items,
    this.child,
  });

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'NativeMenuBar',
      props: {
        'menuItems': items.map((i) => i.toJson()).toList(),
      },
    );
  }
}
