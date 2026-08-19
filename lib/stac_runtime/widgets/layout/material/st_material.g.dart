// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'st_material.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StMaterial _$StMaterialFromJson(Map<String, dynamic> json) => StMaterial(
      materialType: $enumDecodeNullable(
              _$StacMaterialTypeEnumMap, json['materialType']) ??
          StacMaterialType.canvas,
      elevation: (json['elevation'] as num?)?.toDouble() ?? 0.0,
      color: json['color'] as String?,
      shadowColor: json['shadowColor'] as String?,
      surfaceTintColor: json['surfaceTintColor'] as String?,
      textStyle: json['textStyle'] == null
          ? null
          : StacTextStyle.fromJson(json['textStyle']),
      borderRadius: json['borderRadius'] == null
          ? null
          : StacBorderRadius.fromJson(json['borderRadius']),
      borderOnForeground: json['borderOnForeground'] as bool? ?? true,
      clipBehavior:
          $enumDecodeNullable(_$StacClipEnumMap, json['clipBehavior']) ??
              StacClip.none,
      animationDuration: json['animationDuration'] == null
          ? const StacDuration(milliseconds: 200)
          : StacDuration.fromJson(
              json['animationDuration'] as Map<String, dynamic>),
      child: json['child'] == null
          ? null
          : StacWidget.fromJson(json['child'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StMaterialToJson(StMaterial instance) =>
    <String, dynamic>{
      'materialType': _$StacMaterialTypeEnumMap[instance.materialType]!,
      'elevation': instance.elevation,
      'color': instance.color,
      'shadowColor': instance.shadowColor,
      'surfaceTintColor': instance.surfaceTintColor,
      'textStyle': instance.textStyle?.toJson(),
      'borderRadius': instance.borderRadius?.toJson(),
      'borderOnForeground': instance.borderOnForeground,
      'clipBehavior': _$StacClipEnumMap[instance.clipBehavior]!,
      'animationDuration': instance.animationDuration.toJson(),
      'child': instance.child?.toJson(),
      'type': instance.type,
    };

const _$StacMaterialTypeEnumMap = {
  StacMaterialType.canvas: 'canvas',
  StacMaterialType.card: 'card',
  StacMaterialType.circle: 'circle',
  StacMaterialType.button: 'button',
  StacMaterialType.transparency: 'transparency',
};

const _$StacClipEnumMap = {
  StacClip.none: 'none',
  StacClip.hardEdge: 'hardEdge',
  StacClip.antiAlias: 'antiAlias',
  StacClip.antiAliasWithSaveLayer: 'antiAliasWithSaveLayer',
};
