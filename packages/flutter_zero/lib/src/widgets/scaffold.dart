import '../core/element.dart';
import '../core/widget.dart';
import '../navigation/dialog.dart';
import 'widgets.dart';

class SnackBar extends StatelessWidget {
  final Widget content;

  const SnackBar({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      backgroundColor: '#323232',
      child: Padding(
        padding: 14.0,
        child: content,
      ),
    );
  }
}

class Scaffold extends StatelessWidget {
  final Widget? appBar;
  final Widget body;
  final Widget? drawer;
  final Widget? bottomNavigationBar;

  const Scaffold({
    super.key,
    this.appBar,
    required this.body,
    this.drawer,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (appBar != null) appBar!,
        Expanded(child: body),
        if (bottomNavigationBar != null) bottomNavigationBar!,
      ],
    );
  }
}

void showModalBottomSheet({
  required BuildContext context,
  required Widget Function(BuildContext context) builder,
}) {
  showDialog(
    context: context,
    builder: (ctx) => Container(
      backgroundColor: '#FFFFFF',
      child: builder(ctx),
    ),
  );
}
