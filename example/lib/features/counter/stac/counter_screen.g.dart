// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_screen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterScreen _$CounterScreenFromJson(Map<String, dynamic> json) =>
    CounterScreen(
      title: json['title'] as String,
      description: json['description'] as String,
      initialCount: (json['initialCount'] as num).toInt(),
    );

Map<String, dynamic> _$CounterScreenToJson(CounterScreen instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'initialCount': instance.initialCount,
      'type': instance.type,
    };
