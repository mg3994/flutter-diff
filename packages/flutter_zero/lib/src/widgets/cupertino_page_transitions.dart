import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import '../navigation/navigator.dart';
import 'widgets.dart';

class CupertinoPageRoute<T> extends PageRoute<T> {
  final Widget Function(BuildContext context) builder;

  CupertinoPageRoute({required this.builder}) : super(builder: builder);
}

class CupertinoSheetRoute<T> extends PageRoute<T> {
  final Widget Function(BuildContext context) builder;

  CupertinoSheetRoute({required this.builder}) : super(builder: builder);
}
