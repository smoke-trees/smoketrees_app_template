// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'st_conditional_widget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StConditionalWidget _$StConditionalWidgetFromJson(Map<String, dynamic> json) =>
    StConditionalWidget(
      when: json['when'],
      whenTrue: json['whenTrue'] == null
          ? null
          : StacWidget.fromJson(json['whenTrue'] as Map<String, dynamic>),
      whenFalse: json['whenFalse'] == null
          ? null
          : StacWidget.fromJson(json['whenFalse'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StConditionalWidgetToJson(
        StConditionalWidget instance) =>
    <String, dynamic>{
      'when': instance.when,
      'whenTrue': instance.whenTrue?.toJson(),
      'whenFalse': instance.whenFalse?.toJson(),
      'type': instance.type,
    };
