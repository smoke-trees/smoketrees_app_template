import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_delete_to_do_action.g.dart';

/// Deletes a to-do by [id].
///
/// ```json
/// { "actionType": "delete_to_do", "id": "{{id}}" }
/// ```
@JsonSerializable(explicitToJson: true)
class StacDeleteToDoAction extends StacAction {
  const StacDeleteToDoAction({required this.id});

  final String id;

  @override
  String get actionType => 'delete_to_do';

  factory StacDeleteToDoAction.fromJson(Map<String, dynamic> json) =>
      _$StacDeleteToDoActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StacDeleteToDoActionToJson(this);
}
