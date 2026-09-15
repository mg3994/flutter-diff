import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class CalendarDatePicker extends NativeRenderWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final void Function(DateTime date)? onDateChanged;

  const CalendarDatePicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateChanged,
  });

  @override
  Element createElement() => CalendarDatePickerElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return CalendarDatePickerRenderNode(
      props: {
        'initialDate': initialDate.toIso8601String(),
        'firstDate': firstDate.toIso8601String(),
        'lastDate': lastDate.toIso8601String(),
      },
    );
  }
}

class CalendarDatePickerRenderNode extends NativeRenderNode {
  CalendarDatePickerRenderNode({required super.props})
      : super(widgetType: 'CalendarDatePicker');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(Size(
      constraints.maxWidth.isFinite ? constraints.maxWidth : 320.0,
      300.0,
    ));
  }
}

class CalendarDatePickerElement extends NativeRenderElement {
  CalendarDatePickerElement(CalendarDatePicker super.widget);

  @override
  CalendarDatePicker get widget => super.widget as CalendarDatePicker;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    renderNode?.onNativeHandleCreated = (handle) {
      _registerEvents(handle);
    };
    if (renderNode?.nativeHandle != null) {
      _registerEvents(renderNode!.nativeHandle!);
    }
  }

  void _registerEvents(int handle) {
    final backend = appOwner?.backend;
    if (backend != null && widget.onDateChanged != null) {
      backend.registerEventListener(handle, 'dateChange', (name, data) {
        final iso = data['isoString'] as String?;
        if (iso != null) {
          final dt = DateTime.tryParse(iso);
          if (dt != null) widget.onDateChanged?.call(dt);
        }
      });
    }
  }
}
