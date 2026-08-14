// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_reorder_to_do_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StacReorderToDoAction _$StacReorderToDoActionFromJson(
  Map<String, dynamic> json,
) => StacReorderToDoAction(
  id: json['id'],
  userId: json['userId'],
  fromIndex: json['fromIndex'],
  toIndex: json['toIndex'],
);

Map<String, dynamic> _$StacReorderToDoActionToJson(
  StacReorderToDoAction instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'fromIndex': instance.fromIndex,
  'toIndex': instance.toIndex,
  'actionType': instance.actionType,
};
