// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'st_animated_container.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StAnimatedContainer _$StAnimatedContainerFromJson(Map<String, dynamic> json) =>
    StAnimatedContainer(
      durationMs: (json['durationMs'] as num?)?.toInt() ?? 200,
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      padding: json['padding'] == null
          ? null
          : StacEdgeInsets.fromJson(json['padding']),
      margin: json['margin'] == null
          ? null
          : StacEdgeInsets.fromJson(json['margin']),
      alignment: json['alignment'] as String?,
      decoration: json['decoration'] == null
          ? null
          : StacBoxDecoration.fromJson(
              json['decoration'] as Map<String, dynamic>,
            ),
      decorationWhen: json['decorationWhen'],
      decorationWhenTrue: json['decorationWhenTrue'] == null
          ? null
          : StacBoxDecoration.fromJson(
              json['decorationWhenTrue'] as Map<String, dynamic>,
            ),
      decorationWhenFalse: json['decorationWhenFalse'] == null
          ? null
          : StacBoxDecoration.fromJson(
              json['decorationWhenFalse'] as Map<String, dynamic>,
            ),
      child: json['child'] == null
          ? null
          : StacWidget.fromJson(json['child'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StAnimatedContainerToJson(
  StAnimatedContainer instance,
) => <String, dynamic>{
  'durationMs': instance.durationMs,
  'width': instance.width,
  'height': instance.height,
  'padding': instance.padding?.toJson(),
  'margin': instance.margin?.toJson(),
  'alignment': instance.alignment,
  'decoration': instance.decoration?.toJson(),
  'decorationWhen': instance.decorationWhen,
  'decorationWhenTrue': instance.decorationWhenTrue?.toJson(),
  'decorationWhenFalse': instance.decorationWhenFalse?.toJson(),
  'child': instance.child?.toJson(),
  'type': instance.type,
};
