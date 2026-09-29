import '../core/element.dart';
import '../core/widget.dart';
import 'theme.dart';
import 'widgets.dart';

enum TargetPlatform { android, iOS, macOS, windows, linux }

class AdaptiveButton extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;
  final TargetPlatform? platform;

  const AdaptiveButton({
    super.key,
    required this.child,
    this.onPressed,
    this.platform,
  });

  @override
  Widget build(BuildContext context) {
    final target = platform ?? TargetPlatform.android;
    final theme = Theme.of(context);

    if (target == TargetPlatform.iOS || target == TargetPlatform.macOS) {
      return Container(
        backgroundColor: theme.primaryColor,
        child: Padding(
          padding: 8.0,
          child: Button(
            onPressed: onPressed,
            child: child,
          ),
        ),
      );
    }

    return Button(
      onPressed: onPressed,
      child: child,
    );
  }
}

class AdaptiveTextField extends StatelessWidget {
  final String? placeholder;
  final String? initialValue;
  final void Function(String text)? onChanged;
  final TargetPlatform? platform;

  const AdaptiveTextField({
    super.key,
    this.placeholder,
    this.initialValue,
    this.onChanged,
    this.platform,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      placeholder: placeholder,
      initialValue: initialValue,
      onChanged: onChanged,
    );
  }
}
