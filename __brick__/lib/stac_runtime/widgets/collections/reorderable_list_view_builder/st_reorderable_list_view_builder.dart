import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_reorderable_list_view_builder.g.dart';

@JsonSerializable(explicitToJson: true)
class StReorderableListViewBuilder extends StacWidget {
  const StReorderableListViewBuilder({
    this.endpoint,
    this.items,
    required this.itemTemplate,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.padding,
    this.shrinkWrap = false,
    this.reverse = false,
    this.scrollDirection,
    this.spacing,
    this.separator,
    this.enablePagination = false,
    this.page = 1,
    this.count = 20,
    this.orderBy,
    this.order = 'ASC',
    this.queryParams,
    this.footerLoadingWidget,
    this.onReorder,
  });

  final String? endpoint;
  final List<Map<String, dynamic>>? items;
  final StacWidget itemTemplate;
  final Map<String, dynamic>? loadingWidget;
  final Map<String, dynamic>? errorWidget;
  final Map<String, dynamic>? emptyWidget;
  final StacEdgeInsets? padding;
  final bool shrinkWrap;
  final bool reverse;
  final String? scrollDirection;
  final double? spacing;
  final StacWidget? separator;
  final bool enablePagination;
  final int page;
  final int count;
  final String? orderBy;
  final String order;
  final Map<String, dynamic>? queryParams;
  final Map<String, dynamic>? footerLoadingWidget;
  final StacAction? onReorder;

  @override
  String get type => 'reorderable_list_view_builder';

  factory StReorderableListViewBuilder.fromJson(Map<String, dynamic> json) =>
      _$StReorderableListViewBuilderFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StReorderableListViewBuilderToJson(this);
}
