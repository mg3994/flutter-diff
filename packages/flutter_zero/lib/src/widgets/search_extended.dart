import '../core/element.dart';
import '../core/render_node.dart';
import '../core/widget.dart';
import 'widgets.dart';

typedef SearchSuggestionsBuilder = List<Widget> Function(BuildContext context, String query);

class SearchAnchor extends NativeRenderWidget {
  final Widget builder;
  final SearchSuggestionsBuilder suggestionsBuilder;

  const SearchAnchor({
    super.key,
    required this.builder,
    required this.suggestionsBuilder,
  });

  @override
  Element createElement() => SearchAnchorElement(this);

  @override
  NativeRenderNode createRenderNode() {
    return SingleChildNativeRenderNode(widgetType: 'SearchAnchor');
  }
}

class SearchAnchorElement extends NativeRenderElement {
  Element? _builderEl;

  SearchAnchorElement(SearchAnchor super.widget);

  @override
  SearchAnchor get widget => super.widget as SearchAnchor;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _builderEl = widget.builder.createElement()..mount(this);
    if (_builderEl?.renderNode != null) {
      (renderNode as SingleChildNativeRenderNode).child = _builderEl!.renderNode;
    }
  }

  @override
  void unmount() {
    _builderEl?.unmount();
    super.unmount();
  }

  @override
  void visitChildren(void Function(Element element) visitor) {
    if (_builderEl != null) visitor(_builderEl!);
  }
}
