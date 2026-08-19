// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'to_do_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ToDoListModel _$ToDoListModelFromJson(Map<String, dynamic> json) =>
    ToDoListModel(
      appBarTitle: json['appBarTitle'] as String,
      toDoTileModel:
          ToDoTileModel.fromJson(json['toDoTileModel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ToDoListModelToJson(ToDoListModel instance) =>
    <String, dynamic>{
      'appBarTitle': instance.appBarTitle,
      'toDoTileModel': instance.toDoTileModel.toJson(),
      'type': instance.type,
    };

ToDoTileModel _$ToDoTileModelFromJson(Map<String, dynamic> json) =>
    ToDoTileModel(
      serialNumberMarkWidth:
          (json['serialNumberMarkWidth'] as num?)?.toDouble() ?? 32,
      serialNumberMarkHeight:
          (json['serialNumberMarkHeight'] as num?)?.toDouble() ?? 32,
    );

Map<String, dynamic> _$ToDoTileModelToJson(ToDoTileModel instance) =>
    <String, dynamic>{
      'serialNumberMarkWidth': instance.serialNumberMarkWidth,
      'serialNumberMarkHeight': instance.serialNumberMarkHeight,
    };
