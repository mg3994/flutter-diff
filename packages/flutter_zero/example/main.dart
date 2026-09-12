import 'package:flutter_zero/flutter_zero.dart';

class SamplePainter extends CustomPainter {
  @override
  void paint(NativeCanvas canvas, Size size) {
    canvas.drawRect(Offset.zero, size, '#E0E0E0');
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 20.0, '#FF0000');
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), '#0066CC', 2.0);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);

    return Container(
      backgroundColor: theme.backgroundColor,
      child: Padding(
        padding: 20.0,
        child: Column(
          children: [
            Text(
              'Flutter Zero Screen (${media.orientation.name.toUpperCase()} mode)',
              fontSize: theme.defaultFontSize + 4.0,
              color: theme.textColor,
            ),
            const SizedBox(height: 15.0),
            Text('Device Pixel Ratio: ${media.devicePixelRatio}'),
            const SizedBox(height: 15.0),
            CustomPaint(
              painter: SamplePainter(),
              size: const Size(200.0, 100.0),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  final backend = VirtualNativeUIBackend();

  const mediaData = MediaQueryData(
    size: Size(1024.0, 768.0),
    devicePixelRatio: 2.0,
  );

  final app = FlutterZeroApp(
    rootWidget: const MediaQuery(
      data: mediaData,
      child: HomeScreen(),
    ),
    backend: backend,
  );

  print('=== Initializing Flutter Zero App with MediaQuery & CustomPaint ===');
  app.run();

  print('\n=== Native View Tree on Mount ===');
  print(backend.printTree());
}
