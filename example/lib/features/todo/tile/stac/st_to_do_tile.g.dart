// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'st_to_do_tile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StToDoTile _$StToDoTileFromJson(Map<String, dynamic> json) => StToDoTile(
  id: json['id'] as String?,
  title: json['title'] as String?,
  description: json['description'] as String?,
  serialNumber: json['serialNumber'],
  completed: json['completed'],
  serialNumberMarkWidth: (json['serialNumberMarkWidth'] as num?)?.toDouble(),
  serialNumberMarkHeight: (json['serialNumberMarkHeight'] as num?)?.toDouble(),
  completeColor: json['completeColor'] as String?,
  deleteColor: json['deleteColor'] as String?,
  onToggleComplete: json['onToggleComplete'] == null
      ? null
      : StacAction.fromJson(json['onToggleComplete'] as Map<String, dynamic>),
  onDelete: json['onDelete'] == null
      ? null
      : StacAction.fromJson(json['onDelete'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StToDoTileToJson(StToDoTile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'serialNumber': instance.serialNumber,
      'completed': instance.completed,
      'serialNumberMarkWidth': instance.serialNumberMarkWidth,
      'serialNumberMarkHeight': instance.serialNumberMarkHeight,
      'completeColor': instance.completeColor,
      'deleteColor': instance.deleteColor,
      'onToggleComplete': instance.onToggleComplete?.toJson(),
      'onDelete': instance.onDelete?.toJson(),
      'type': instance.type,
    };
