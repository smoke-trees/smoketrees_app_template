import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'stac_reorder_to_do_action.g.dart';

/// A custom [StacAction] that persists a to-do reorder to the server.
///
/// Used as the [StReorderableListViewBuilder.onReorder] action. Fields hold
/// `{{placeholder}}` strings which the reorderable list resolves at runtime:
/// `{{id}}` is the moved item's id, `{{newIndex}}`/`{{toIndex}}` its new
/// position.
///
/// ```json
/// {
///   "actionType": "reorder_to_do",
///   "id": "{{id}}",
///   "toIndex": "{{newIndex}}"
/// }
/// ```
@JsonSerializable()
class StacReorderToDoAction extends StacAction {
  const StacReorderToDoAction({
    this.id,
    this.userId,
    this.fromIndex,
    this.toIndex,
  });

  /// Id of the moved to-do. Usually `{{id}}`.
  final Object? id;

  /// User that owns the to-do. Defaults to the signed-in user when null.
  final Object? userId;

  /// Source position of the moved item. Usually `{{oldIndex}}`.
  final Object? fromIndex;

  /// New position of the moved item. Usually `{{newIndex}}`.
  final Object? toIndex;

  @override
  String get actionType => 'reorder_to_do';

  factory StacReorderToDoAction.fromJson(Map<String, dynamic> json) =>
      _$StacReorderToDoActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StacReorderToDoActionToJson(this);
}
