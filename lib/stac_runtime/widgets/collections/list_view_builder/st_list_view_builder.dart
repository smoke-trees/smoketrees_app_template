import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_list_view_builder.g.dart';

/// A data-driven [ListView.builder] whose items are Stac widget JSON templates.
///
/// Data can come from an [endpoint] (fetched via Dio) or from an inline
/// [items] array. Each item is rendered by injecting its fields into
/// [itemTemplate] via `{{key}}` placeholders, plus the special `{{index}}`
/// placeholder for the zero-based position.
///
/// Pagination mirrors the project's `EntityDio.readMany` contract: the server
/// is queried with `page`, `count` (page size), `orderBy` and `order` params and
/// responds with:
///
/// ```json
/// {
///   "status": { "code": "200", "error": false },
///   "message": "Success in readMany",
///   "result": [ { "id": "â€¦", "title": "â€¦", "...": "â€¦" } ],
///   "count": 10
/// }
/// ```
///
/// In this contract `result` holds the current page's items and `count` is the
/// number of items returned on that page (a short page means there are no more
/// results). When [enablePagination] is true, the next page is fetched
/// automatically as the user scrolls to the bottom.
///
/// ```json
/// {
///   "type": "list_view_builder",
///   "endpoint": "/to-do",
///   "enablePagination": true,
///   "count": 20,
///   "orderBy": "serialNumber",
///   "order": "ASC",
///   "queryParams": { "userId": "1" },
///   "itemTemplate": {
///     "type": "container",
///     "child": { "type": "text", "data": "{{title}}" }
///   },
///   "loadingWidget": { "type": "center", "child": { "type": "circularProgressIndicator" } },
///   "errorWidget": { "type": "center", "child": { "type": "text", "data": "Failed to load" } },
///   "emptyWidget": { "type": "center", "child": { "type": "text", "data": "No items" } },
///   "footerLoadingWidget": { "type": "center", "child": { "type": "circularProgressIndicator" } }
/// }
/// ```
@JsonSerializable(explicitToJson: true)
class StListViewBuilder extends StacWidget {
  const StListViewBuilder({
    this.endpoint,
    this.items,
    required this.itemTemplate,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.padding,
    this.shrinkWrap = false,
    this.reverse = false,
    this.separator,
    this.scrollDirection,
    this.enablePagination = false,
    this.page = 1,
    this.count = 20,
    this.orderBy,
    this.order = 'ASC',
    this.queryParams,
    this.footerLoadingWidget,
  });

  /// Optional endpoint to fetch the item list from. When null, [items] is used.
  final String? endpoint;

  /// Inline item data used when [endpoint] is null.
  final List<Map<String, dynamic>>? items;

  /// Stac widget rendered for every item. `{{key}}` placeholders are
  /// replaced with the item's fields, and `{{index}}` with its position.
  ///
  /// Can be a typed Stac widget (e.g. `StacText(data: '{{title}}')`) or a raw
  /// JSON map from a server payload (e.g. `{"type": "text", "data": "{{title}}"}`).
  final StacWidget itemTemplate;

  /// Stac widget JSON shown while [endpoint] is loading.
  final Map<String, dynamic>? loadingWidget;

  /// Stac widget JSON shown when the fetch fails.
  final Map<String, dynamic>? errorWidget;

  /// Stac widget JSON shown when the resolved list is empty.
  final Map<String, dynamic>? emptyWidget;

  /// Padding applied around the list.
  final StacEdgeInsets? padding;

  final bool shrinkWrap;
  final bool reverse;

  /// Optional separator widget JSON rendered between items.
  final Map<String, dynamic>? separator;

  /// One of: horizontal, vertical.
  final String? scrollDirection;

  /// When true, the next page is fetched automatically as the user scrolls to
  /// the bottom of the list. Only applies when [endpoint] is set.
  final bool enablePagination;

  /// Starting page number. Defaults to 1.
  final int page;

  /// Page size sent as the `count` query param. Defaults to 20.
  final int count;

  /// Field used to sort the results, sent as the `orderBy` query param.
  final String? orderBy;

  /// Sort direction (`ASC` or `DESC`), sent as the `order` query param.
  final String order;

  /// Extra query params merged into every page request.
  final Map<String, dynamic>? queryParams;

  /// Stac widget JSON shown at the bottom of the list while the next page is
  /// loading.
  final Map<String, dynamic>? footerLoadingWidget;

  @override
  String get type => 'list_view_builder';

  factory StListViewBuilder.fromJson(Map<String, dynamic> json) =>
      _$StListViewBuilderFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StListViewBuilderToJson(this);
}
