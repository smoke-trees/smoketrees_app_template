import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'to_do_list_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ToDoListModel extends StacWidget {
  final String appBarTitle;
  final ToDoTileModel toDoTileModel;
  const ToDoListModel({required this.appBarTitle, required this.toDoTileModel});

  @override
  String get type => 'to_do_list';

  factory ToDoListModel.fromJson(Map<String, dynamic> json) =>
      _$ToDoListModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ToDoListModelToJson(this);
}

@JsonSerializable()
class ToDoTileModel {
  final double? serialNumberMarkWidth;
  final double? serialNumberMarkHeight;

  ToDoTileModel({
    this.serialNumberMarkWidth = 32,
    this.serialNumberMarkHeight = 32,
  });

  factory ToDoTileModel.fromJson(Map<String, dynamic> json) =>
      _$ToDoTileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ToDoTileModelToJson(this);
}
