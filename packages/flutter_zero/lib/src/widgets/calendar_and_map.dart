import '../core/render_node.dart';
import 'widgets.dart';

class NativeCalendarWidget extends NativeRenderWidget {
  final DateTime? selectedDate;
  final void Function(DateTime date)? onDateSelected;

  const NativeCalendarWidget({
    super.key,
    this.selectedDate,
    this.onDateSelected,
  });

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'NativeCalendar',
      props: {
        'selectedDate': (selectedDate ?? DateTime.now()).toIso8601String(),
      },
    );
  }
}

class NativeMapWidget extends NativeRenderWidget {
  final double latitude;
  final double longitude;
  final double zoom;

  const NativeMapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    this.zoom = 12.0,
  });

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'NativeMap',
      props: {
        'latitude': latitude,
        'longitude': longitude,
        'zoom': zoom,
      },
    );
  }
}
