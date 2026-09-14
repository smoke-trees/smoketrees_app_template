// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'st_generic_data_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StGenericDataList _$StGenericDataListFromJson(Map<String, dynamic> json) =>
    StGenericDataList(
      endpoint: json['endpoint'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      actionKey: json['actionKey'] as String?,
      childTemplate: json['childTemplate'] as Map<String, dynamic>,
      loadingWidget: json['loadingWidget'] as Map<String, dynamic>?,
      errorWidget: json['errorWidget'] as Map<String, dynamic>?,
      emptyWidget: json['emptyWidget'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$StGenericDataListToJson(StGenericDataList instance) =>
    <String, dynamic>{
      'endpoint': instance.endpoint,
      'items': instance.items,
      'actionKey': instance.actionKey,
      'childTemplate': instance.childTemplate,
      'loadingWidget': instance.loadingWidget,
      'errorWidget': instance.errorWidget,
      'emptyWidget': instance.emptyWidget,
      'type': instance.type,
    };
