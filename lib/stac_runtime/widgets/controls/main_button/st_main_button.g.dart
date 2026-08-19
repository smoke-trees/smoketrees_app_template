// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'st_main_button.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StMainButton _$StMainButtonFromJson(Map<String, dynamic> json) => StMainButton(
      actionKey: json['actionKey'] as String?,
      onPressed: json['onPressed'] == null
          ? null
          : StacAction.fromJson(json['onPressed'] as Map<String, dynamic>),
      disabled: json['disabled'] as bool? ?? false,
      showLoader: json['showLoader'] as bool? ?? false,
      isOutlined: json['isOutlined'] as bool? ?? false,
      title: json['title'] as String?,
      textStyle: json['textStyle'] == null
          ? null
          : StacTextStyle.fromJson(json['textStyle']),
      padding: json['padding'] == null
          ? const StacEdgeInsets.symmetric(vertical: 15)
          : StacEdgeInsets.fromJson(json['padding']),
      borderRadius: (json['borderRadius'] as num?)?.toDouble() ?? 30,
      color: json['color'] as String?,
      textColor: json['textColor'] as String?,
      width: (json['width'] as num?)?.toDouble(),
      borderSide: json['borderSide'] == null
          ? null
          : StacBorderSide.fromJson(json['borderSide'] as Map<String, dynamic>),
      loadingColor: json['loadingColor'] as String? ?? StacColors.white,
      fontSize: (json['fontSize'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$StMainButtonToJson(StMainButton instance) =>
    <String, dynamic>{
      'actionKey': instance.actionKey,
      'onPressed': instance.onPressed,
      'title': instance.title,
      'textStyle': instance.textStyle,
      'padding': instance.padding,
      'disabled': instance.disabled,
      'showLoader': instance.showLoader,
      'isOutlined': instance.isOutlined,
      'borderRadius': instance.borderRadius,
      'color': instance.color,
      'textColor': instance.textColor,
      'width': instance.width,
      'fontSize': instance.fontSize,
      'loadingColor': instance.loadingColor,
      'borderSide': instance.borderSide,
      'type': instance.type,
    };
