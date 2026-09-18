import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

class DataColumn {
  final String label;
  final bool numeric;

  const DataColumn({
    required this.label,
    this.numeric = false,
  });

  Map<String, dynamic> toJson() => {
        'label': label,
        'numeric': numeric,
      };
}

class DataCell {
  final Widget child;

  const DataCell(this.child);
}

class DataRow {
  final List<DataCell> cells;
  final bool selected;
  final void Function(bool? value)? onSelectChanged;

  const DataRow({
    required this.cells,
    this.selected = false,
    this.onSelectChanged,
  });
}

/// An enterprise native data table view with virtualized row loading support.
class NativeDataTable extends NativeRenderWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final int? sortColumnIndex;
  final bool sortAscending;

  const NativeDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.sortColumnIndex,
    this.sortAscending = true,
  });

  @override
  NativeRenderNode createRenderNode() {
    final childrenNodes = <NativeRenderNode>[];
    for (final row in rows) {
      for (final cell in row.cells) {
        if (cell.child is NativeRenderWidget) {
          childrenNodes.add((cell.child as NativeRenderWidget).createRenderNode());
        }
      }
    }

    return MultiChildNativeRenderNode(
      widgetType: 'NativeDataTable',
      props: {
        'columns': columns.map((c) => c.toJson()).toList(),
        'rowCount': rows.length,
        'sortColumnIndex': sortColumnIndex,
        'sortAscending': sortAscending,
      },
    );
  }
}

/// Native WebView control for rendering web content via platform WebView.
class NativeWebViewWidget extends NativeRenderWidget {
  final String? initialUrl;
  final String? initialHtml;
  final void Function(String url)? onPageFinished;

  const NativeWebViewWidget({
    super.key,
    this.initialUrl,
    this.initialHtml,
    this.onPageFinished,
  });

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(
      widgetType: 'NativeWebView',
      props: {
        if (initialUrl != null) 'initialUrl': initialUrl,
        if (initialHtml != null) 'initialHtml': initialHtml,
      },
    );
  }
}

/// Server-driven / Dynamic Module UI Loader.
/// Renders server-supplied UI descriptor schemas directly into native Flutter Zero widget trees.
class RemoteWidgetLoader extends StatelessWidget {
  final Map<String, dynamic> schema;

  const RemoteWidgetLoader({
    super.key,
    required this.schema,
  });

  static Widget parseSchema(Map<String, dynamic> schema) {
    final type = schema['type'] as String? ?? 'Container';
    final props = schema['properties'] as Map<String, dynamic>? ?? {};

    switch (type) {
      case 'Text':
        return Text(
          props['text'] as String? ?? '',
          fontSize: (props['fontSize'] as num?)?.toDouble() ?? 14,
        );
      case 'Container':
        return Container(
          width: (props['width'] as num?)?.toDouble(),
          height: (props['height'] as num?)?.toDouble(),
          child: schema['child'] != null ? parseSchema(schema['child'] as Map<String, dynamic>) : null,
        );
      case 'Column':
        final childrenJson = schema['children'] as List? ?? [];
        return Column(
          children: childrenJson.map((c) => parseSchema(c as Map<String, dynamic>)).toList(),
        );
      case 'Row':
        final childrenJson = schema['children'] as List? ?? [];
        return Row(
          children: childrenJson.map((c) => parseSchema(c as Map<String, dynamic>)).toList(),
        );
      case 'Button':
        return Button(
          child: Text(props['label'] as String? ?? 'Button'),
        );
      default:
        return Text('Unknown remote widget: $type');
    }
  }

  @override
  Widget build(BuildContext context) {
    return parseSchema(schema);
  }
}
