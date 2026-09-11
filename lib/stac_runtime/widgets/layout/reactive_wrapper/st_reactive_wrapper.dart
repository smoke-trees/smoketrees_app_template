import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_reactive_wrapper.g.dart';

/// A wrapper that reactively rebuilds its child when data changes.
/// Watches a specific item by [id] from a registered data source
/// and resolves {{placeholder}} tokens with computed values.
@JsonSerializable(explicitToJson: true)
class StReactiveWrapper extends StacWidget {
  const StReactiveWrapper({
    required this.id,
    required this.child,
    required this.dataSourceKey,
  });

  /// The item id to watch for changes.
  final String id;

  /// The Stac widget tree to render with placeholder injection.
  final StacWidget child;

  /// Key identifying the data source to watch (registered in DataRegistry).
  final String dataSourceKey;

  @override
  String get type => 'st_reactive_wrapper';

  factory StReactiveWrapper.fromJson(Map<String, dynamic> json) =>
      _$StReactiveWrapperFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StReactiveWrapperToJson(this);
}
