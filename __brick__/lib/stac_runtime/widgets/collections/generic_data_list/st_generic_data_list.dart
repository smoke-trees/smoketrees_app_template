import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_generic_data_list.g.dart';

/// A generic data-driven list that renders items via a child template.
/// Supports endpoint, inline items, or actionKey data sources.
/// Placeholders like `{{key}}` in childTemplate are replaced with
/// the fetched/inline/action data at runtime.
@JsonSerializable(explicitToJson: true)
class StGenericDataList extends StacWidget {
  const StGenericDataList({
    this.endpoint,
    this.items,
    this.actionKey,
    required this.childTemplate,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
  });

  final String? endpoint;
  final List<Map<String, dynamic>>? items;
  final String? actionKey;
  final Map<String, dynamic> childTemplate;
  final Map<String, dynamic>? loadingWidget;
  final Map<String, dynamic>? errorWidget;
  final Map<String, dynamic>? emptyWidget;

  @override
  String get type => 'st_generic_data_list';

  factory StGenericDataList.fromJson(Map<String, dynamic> json) =>
      _$StGenericDataListFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StGenericDataListToJson(this);
}
