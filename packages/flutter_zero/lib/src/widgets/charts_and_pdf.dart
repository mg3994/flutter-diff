import '../core/render_node.dart';
import 'widgets.dart';

class NativeChartWidget extends NativeRenderWidget {
  final String chartType; // 'bar', 'line', 'pie'
  final List<Map<String, dynamic>> dataPoints;

  const NativeChartWidget({
    super.key,
    required this.chartType,
    required this.dataPoints,
  });

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'NativeChart',
      props: {
        'chartType': chartType,
        'dataPoints': dataPoints,
      },
    );
  }
}

class NativePdfViewer extends NativeRenderWidget {
  final String documentPath;

  const NativePdfViewer({
    super.key,
    required this.documentPath,
  });

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'NativePdfViewer',
      props: {
        'documentPath': documentPath,
      },
    );
  }
}
