import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class TableRow {
  final List<Widget> children;

  const TableRow({this.children = const []});
}

class Table extends NativeRenderWidget {
  final List<TableRow> children;

  const Table({
    super.key,
    this.children = const [],
  });

  @override
  Element createElement() => TableElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'Table');
  }
}

class TableElement extends NativeRenderElement {
  List<Element> _cellElements = [];

  TableElement(Table super.widget);

  @override
  Table get widget => super.widget as Table;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    for (final row in widget.children) {
      for (final cellWidget in row.children) {
        final cellEl = cellWidget.createElement()..mount(this);
        if (cellEl.renderNode != null) {
          multiNode.addChild(cellEl.renderNode!);
        }
        _cellElements.add(cellEl);
      }
    }
  }

  @override
  void unmount() {
    for (final el in _cellElements) {
      el.unmount();
    }
    _cellElements.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    for (final el in _cellElements) {
      visitor(el);
    }
  }
}

class ExpansionPanel {
  final Widget headerBuilder;
  final Widget body;
  final bool isExpanded;

  const ExpansionPanel({
    required this.headerBuilder,
    required this.body,
    this.isExpanded = false,
  });
}

class ExpansionPanelList extends NativeRenderWidget {
  final List<ExpansionPanel> children;
  final void Function(int panelIndex, bool isExpanded)? expansionCallback;

  const ExpansionPanelList({
    super.key,
    this.children = const [],
    this.expansionCallback,
  });

  @override
  Element createElement() => ExpansionPanelListElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(widgetType: 'ExpansionPanelList');
  }
}

class ExpansionPanelListElement extends NativeRenderElement {
  List<Element> _panelElements = [];

  ExpansionPanelListElement(ExpansionPanelList super.widget);

  @override
  ExpansionPanelList get widget => super.widget as ExpansionPanelList;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    for (final panel in widget.children) {
      final headerEl = panel.headerBuilder.createElement()..mount(this);
      if (headerEl.renderNode != null) multiNode.addChild(headerEl.renderNode!);
      _panelElements.add(headerEl);

      if (panel.isExpanded) {
        final bodyEl = panel.body.createElement()..mount(this);
        if (bodyEl.renderNode != null) multiNode.addChild(bodyEl.renderNode!);
        _panelElements.add(bodyEl);
      }
    }

    renderNode?.onNativeHandleCreated = (handle) {
      _registerEvents(handle);
    };
    if (renderNode?.nativeHandle != null) {
      _registerEvents(renderNode!.nativeHandle!);
    }
  }

  void _registerEvents(int handle) {
    final backend = appOwner?.backend;
    if (backend != null && widget.expansionCallback != null) {
      backend.registerEventListener(handle, 'expandToggle', (eventName, data) {
        final index = (data['index'] as num?)?.toInt() ?? 0;
        final isExpanded = (data['isExpanded'] as bool?) ?? false;
        widget.expansionCallback?.call(index, isExpanded);
      });
    }
  }

  @override
  void unmount() {
    for (final el in _panelElements) {
      el.unmount();
    }
    _panelElements.clear();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    for (final el in _panelElements) {
      visitor(el);
    }
  }
}
