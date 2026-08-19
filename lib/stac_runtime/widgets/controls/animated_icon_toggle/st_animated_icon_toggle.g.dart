// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'st_animated_icon_toggle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StAnimatedIconToggle _$StAnimatedIconToggleFromJson(
        Map<String, dynamic> json) =>
    StAnimatedIconToggle(
      when: json['when'],
      trueIcon: json['trueIcon'] as String,
      falseIcon: json['falseIcon'] as String,
      trueColor: json['trueColor'] as String?,
      falseColor: json['falseColor'] as String?,
      size: (json['size'] as num?)?.toDouble() ?? 24,
      durationMs: (json['durationMs'] as num?)?.toInt() ?? 200,
      onTap: json['onTap'] == null
          ? null
          : StacAction.fromJson(json['onTap'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StAnimatedIconToggleToJson(
        StAnimatedIconToggle instance) =>
    <String, dynamic>{
      'when': instance.when,
      'trueIcon': instance.trueIcon,
      'falseIcon': instance.falseIcon,
      'trueColor': instance.trueColor,
      'falseColor': instance.falseColor,
      'size': instance.size,
      'durationMs': instance.durationMs,
      'onTap': instance.onTap?.toJson(),
      'type': instance.type,
    };
