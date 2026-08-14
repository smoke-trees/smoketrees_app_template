// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'st_dismissible.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StDismissible _$StDismissibleFromJson(Map<String, dynamic> json) =>
    StDismissible(
      keyValue: json['keyValue'] as String?,
      direction: json['direction'] as String? ?? 'horizontal',
      background: json['background'] == null
          ? null
          : StacWidget.fromJson(json['background'] as Map<String, dynamic>),
      secondaryBackground: json['secondaryBackground'] == null
          ? null
          : StacWidget.fromJson(
              json['secondaryBackground'] as Map<String, dynamic>,
            ),
      confirmDialog: json['confirmDialog'] == null
          ? null
          : StDismissibleConfirmDialog.fromJson(
              json['confirmDialog'] as Map<String, dynamic>,
            ),
      onStartToEnd: json['onStartToEnd'] == null
          ? null
          : StacAction.fromJson(json['onStartToEnd'] as Map<String, dynamic>),
      onEndToStart: json['onEndToStart'] == null
          ? null
          : StacAction.fromJson(json['onEndToStart'] as Map<String, dynamic>),
      child: json['child'] == null
          ? null
          : StacWidget.fromJson(json['child'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StDismissibleToJson(StDismissible instance) =>
    <String, dynamic>{
      'keyValue': instance.keyValue,
      'direction': instance.direction,
      'background': instance.background?.toJson(),
      'secondaryBackground': instance.secondaryBackground?.toJson(),
      'confirmDialog': instance.confirmDialog?.toJson(),
      'onStartToEnd': instance.onStartToEnd?.toJson(),
      'onEndToStart': instance.onEndToStart?.toJson(),
      'child': instance.child?.toJson(),
      'type': instance.type,
    };

StDismissibleConfirmDialog _$StDismissibleConfirmDialogFromJson(
  Map<String, dynamic> json,
) => StDismissibleConfirmDialog(
  title: json['title'] as String,
  message: json['message'] as String,
  cancelLabel: json['cancelLabel'] as String? ?? 'Cancel',
  confirmLabel: json['confirmLabel'] as String? ?? 'Confirm',
  confirmColor: json['confirmColor'] as String?,
);

Map<String, dynamic> _$StDismissibleConfirmDialogToJson(
  StDismissibleConfirmDialog instance,
) => <String, dynamic>{
  'title': instance.title,
  'message': instance.message,
  'cancelLabel': instance.cancelLabel,
  'confirmLabel': instance.confirmLabel,
  'confirmColor': instance.confirmColor,
};
