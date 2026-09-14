import '../core/render_node.dart';
import 'widgets.dart';

class NativeBarcodeScanner extends NativeRenderWidget {
  final void Function(String code)? onBarcodeScanned;

  const NativeBarcodeScanner({
    super.key,
    this.onBarcodeScanned,
  });

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'NativeBarcodeScanner',
      props: {},
    );
  }
}
