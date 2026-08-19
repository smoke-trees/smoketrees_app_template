// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'st_custom_bottom_bar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StCustomBottomBar _$StCustomBottomBarFromJson(Map<String, dynamic> json) =>
    StCustomBottomBar(
      labels:
          (json['labels'] as List<dynamic>).map((e) => e as String).toList(),
      svgIcons:
          (json['svgIcons'] as List<dynamic>).map((e) => e as String).toList(),
      svgFilledIcons: (json['svgFilledIcons'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      specialIndex: (json['specialIndex'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StCustomBottomBarToJson(StCustomBottomBar instance) =>
    <String, dynamic>{
      'labels': instance.labels,
      'svgIcons': instance.svgIcons,
      'svgFilledIcons': instance.svgFilledIcons,
      'specialIndex': instance.specialIndex,
      'type': instance.type,
    };
