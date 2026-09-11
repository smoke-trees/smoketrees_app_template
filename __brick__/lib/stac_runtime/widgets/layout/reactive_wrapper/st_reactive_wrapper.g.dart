// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'st_reactive_wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StReactiveWrapper _$StReactiveWrapperFromJson(Map<String, dynamic> json) =>
    StReactiveWrapper(
      id: json['id'] as String,
      child: StacWidget.fromJson(json['child'] as Map<String, dynamic>),
      dataSourceKey: json['dataSourceKey'] as String,
    );

Map<String, dynamic> _$StReactiveWrapperToJson(StReactiveWrapper instance) =>
    <String, dynamic>{
      'id': instance.id,
      'child': instance.child.toJson(),
      'dataSourceKey': instance.dataSourceKey,
      'type': instance.type,
    };
