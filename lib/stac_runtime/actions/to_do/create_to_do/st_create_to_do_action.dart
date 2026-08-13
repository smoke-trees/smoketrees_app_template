import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_create_to_do_action.g.dart';

/// Reads title/description from the enclosing StacForm and creates a to-do.
///
/// ```json
/// { "actionType": "create_to_do" }
/// ```
@JsonSerializable(explicitToJson: true)
class StCreateToDoAction extends StacAction {
  const StCreateToDoAction();

  @override
  String get actionType => 'create_to_do';

  factory StCreateToDoAction.fromJson(Map<String, dynamic> json) =>
      _$StCreateToDoActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StCreateToDoActionToJson(this);
}
