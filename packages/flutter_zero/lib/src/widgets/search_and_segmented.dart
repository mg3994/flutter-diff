import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class SearchBar extends NativeRenderWidget {
  final String? hintText;
  final void Function(String query)? onChanged;
  final void Function(String query)? onSubmitted;

  const SearchBar({
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Element createElement() => SearchBarElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SearchBarRenderNode(
      props: {if (hintText != null) 'hintText': hintText},
    );
  }
}

class SearchBarRenderNode extends NativeRenderNode {
  SearchBarRenderNode({required super.props}) : super(widgetType: 'SearchBar');

  @override
  void performLayout(BoxConstraints constraints) {
    size = constraints.constrain(Size(
      constraints.maxWidth.isFinite ? constraints.maxWidth : 300.0,
      56.0,
    ));
  }
}

class SearchBarElement extends NativeRenderElement {
  SearchBarElement(SearchBar super.widget);

  @override
  SearchBar get widget => super.widget as SearchBar;

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
    if (backend != null) {
      if (widget.onChanged != null) {
        backend.registerEventListener(handle, 'change', (eventName, data) {
          final query = (data['text'] as String?) ?? '';
          widget.onChanged?.call(query);
        });
      }
      if (widget.onSubmitted != null) {
        backend.registerEventListener(handle, 'submit', (eventName, data) {
          final query = (data['text'] as String?) ?? '';
          widget.onSubmitted?.call(query);
        });
      }
    }
  }
}

class ButtonSegment<T> {
  final T value;
  final Widget label;

  const ButtonSegment({
    required this.value,
    required this.label,
  });
}

class SegmentedButton<T> extends NativeRenderWidget {
  final Set<T> selected;
  final List<ButtonSegment<T>> segments;
  final void Function(Set<T> newSelection)? onSelectionChanged;

  const SegmentedButton({
    super.key,
    required this.selected,
    required this.segments,
    this.onSelectionChanged,
  });

  @override
  Element createElement() => SegmentedButtonElement<T>(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'SegmentedButton');
  }
}

class SegmentedButtonElement<T> extends NativeRenderElement {
  List<Element> _segmentLabelElements = [];

  SegmentedButtonElement(SegmentedButton<T> super.widget);

  @override
  SegmentedButton<T> get widget => super.widget as SegmentedButton<T>;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    _segmentLabelElements = widget.segments.map((seg) {
      final el = seg.label.createElement()..mount(this);
      if (el.renderNode != null) multiNode.addChild(el.renderNode!);
      return el;
    }).toList();

    renderNode?.onNativeHandleCreated = (handle) {
      _registerEvents(handle);
    };
    if (renderNode?.nativeHandle != null) {
      _registerEvents(renderNode!.nativeHandle!);
    }
  }

  void _registerEvents(int handle) {
    final backend = appOwner?.backend;
    if (backend != null && widget.onSelectionChanged != null) {
      backend.registerEventListener(handle, 'select', (eventName, data) {
        final index = (data['index'] as num?)?.toInt() ?? 0;
        if (index >= 0 && index < widget.segments.length) {
          widget.onSelectionChanged?.call({widget.segments[index].value});
        }
      });
    }
  }

  @override
  void unmount() {
    for (final el in _segmentLabelElements) {
      el.unmount();
    }
    _segmentLabelElements.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    for (final el in _segmentLabelElements) {
      visitor(el);
    }
  }
}
