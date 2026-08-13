import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_toggle_to_do_action.g.dart';

/// Toggles a to-do's completed state.
///
/// Only [id] is required â€” the parser looks up the current [ToDo] from
/// [ToDoListController] and flips `completed` itself, so this action stays
/// correct even if it's dispatched from a stale/cached item template.
///
/// ```json
/// { "actionType": "toggle_to_do", "id": "{{id}}" }
/// ```
@JsonSerializable(explicitToJson: true)
class StacToggleToDoAction extends StacAction {
  const StacToggleToDoAction({required this.id});

  final String id;

  @override
  String get actionType => 'toggle_to_do';

  factory StacToggleToDoAction.fromJson(Map<String, dynamic> json) =>
      _$StacToggleToDoActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StacToggleToDoActionToJson(this);
}
