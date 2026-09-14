// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'st_progress_header.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StProgressHeader _$StProgressHeaderFromJson(Map<String, dynamic> json) =>
    StProgressHeader(
      total: (json['total'] as num).toInt(),
      completed: (json['completed'] as num).toInt(),
      backgroundColor: json['backgroundColor'] as String?,
      progressColor: json['progressColor'] as String?,
      completedMessages: (json['completedMessages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      zeroMessages: (json['zeroMessages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      partialMessages: (json['partialMessages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$StProgressHeaderToJson(StProgressHeader instance) =>
    <String, dynamic>{
      'total': instance.total,
      'completed': instance.completed,
      'backgroundColor': instance.backgroundColor,
      'progressColor': instance.progressColor,
      'completedMessages': instance.completedMessages,
      'zeroMessages': instance.zeroMessages,
      'partialMessages': instance.partialMessages,
      'type': instance.type,
    };
