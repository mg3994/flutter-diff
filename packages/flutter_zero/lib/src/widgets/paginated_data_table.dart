import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'enterprise_controls.dart';
import 'widgets.dart';

abstract class DataTableSource {
  DataRow? getRow(int index);
  int get rowCount;
  bool get isRowCountApproximate;
}

class PaginatedDataTable extends NativeRenderWidget {
  final Widget? header;
  final List<DataColumn> columns;
  final DataTableSource source;
  final int rowsPerPage;

  const PaginatedDataTable({
    super.key,
    this.header,
    required this.columns,
    required this.source,
    this.rowsPerPage = 10,
  });

  @override
  Element createElement() => PaginatedDataTableElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return MultiChildNativeRenderNode(
      widgetType: 'PaginatedDataTable',
      props: {
        'columnCount': columns.length,
        'rowCount': source.rowCount,
        'rowsPerPage': rowsPerPage,
      },
    );
  }
}

class PaginatedDataTableElement extends NativeRenderElement {
  Element? _headerEl;

  PaginatedDataTableElement(PaginatedDataTable super.widget);

  @override
  PaginatedDataTable get widget => super.widget as PaginatedDataTable;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    final multiNode = renderNode as MultiChildNativeRenderNode;

    if (widget.header != null) {
      _headerEl = widget.header!.createElement()..mount(this);
      if (_headerEl?.renderNode != null) multiNode.addChild(_headerEl!.renderNode!);
    }
  }

  @override
  void unmount() {
    _headerEl?.unmount();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_headerEl != null) visitor(_headerEl!);
  }
}
