// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'st_dropdown_button_form_field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StDropdownButtonFormField _$StDropdownButtonFormFieldFromJson(
        Map<String, dynamic> json) =>
    StDropdownButtonFormField(
      id: json['id'] as String?,
      endpoint: json['endpoint'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      actionKey: json['actionKey'] as String?,
      itemTemplate: json['itemTemplate'] as Map<String, dynamic>,
      valueKey: json['valueKey'] as String? ?? 'value',
      initialValue: json['initialValue'] as String?,
      onChanged: _actionFromJson(json['onChanged']),
      hint: json['hint'] as String?,
      inputDecorationTheme:
          _decorationThemeFromJson(json['inputDecorationTheme']),
      labelText: json['labelText'] as String?,
      helperText: json['helperText'] as String?,
      errorText: json['errorText'] as String?,
      loadingWidget: json['loadingWidget'] as Map<String, dynamic>?,
      errorWidget: json['errorWidget'] as Map<String, dynamic>?,
      emptyWidget: json['emptyWidget'] as Map<String, dynamic>?,
      isExpanded: json['isExpanded'] as bool? ?? false,
      isDense: json['isDense'] as bool? ?? false,
      menuMaxHeight: (json['menuMaxHeight'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$StDropdownButtonFormFieldToJson(
        StDropdownButtonFormField instance) =>
    <String, dynamic>{
      'id': instance.id,
      'endpoint': instance.endpoint,
      'items': instance.items,
      'actionKey': instance.actionKey,
      'itemTemplate': instance.itemTemplate,
      'valueKey': instance.valueKey,
      'initialValue': instance.initialValue,
      'onChanged': _actionToJson(instance.onChanged),
      'hint': instance.hint,
      'inputDecorationTheme':
          _decorationThemeToJson(instance.inputDecorationTheme),
      'labelText': instance.labelText,
      'helperText': instance.helperText,
      'errorText': instance.errorText,
      'loadingWidget': instance.loadingWidget,
      'errorWidget': instance.errorWidget,
      'emptyWidget': instance.emptyWidget,
      'isExpanded': instance.isExpanded,
      'isDense': instance.isDense,
      'menuMaxHeight': instance.menuMaxHeight,
      'type': instance.type,
    };
