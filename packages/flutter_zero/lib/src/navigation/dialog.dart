import '../core/element.dart';
import '../core/widget.dart';
import '../widgets/widgets.dart';
import 'navigator.dart';

class AlertDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget> actions;

  const AlertDialog({
    super.key,
    this.title,
    this.content,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      backgroundColor: '#FFFFFF',
      child: Padding(
        padding: 20.0,
        child: Column(
          children: [
            if (title != null) title!,
            if (content != null) ...[
              const SizedBox(height: 10.0),
              content!,
            ],
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 15.0),
              Row(children: actions),
            ],
          ],
        ),
      ),
    );
  }
}

void showDialog({
  required BuildContext context,
  required Widget Function(BuildContext context) builder,
}) {
  Navigator.push(
    context,
    PageRoute(
      builder: (ctx) => Center(
        child: builder(ctx),
      ),
    ),
  );
}
