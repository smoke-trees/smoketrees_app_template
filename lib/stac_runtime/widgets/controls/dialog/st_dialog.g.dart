// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'st_dialog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StDialog _$StDialogFromJson(Map<String, dynamic> json) => StDialog(
  backgroundColor: json['backgroundColor'] as String?,
  elevation: (json['elevation'] as num?)?.toDouble(),
  shadowColor: json['shadowColor'] as String?,
  surfaceTintColor: json['surfaceTintColor'] as String?,
  insetAnimationDuration: json['insetAnimationDuration'] == null
      ? null
      : StacDuration.fromJson(
          json['insetAnimationDuration'] as Map<String, dynamic>,
        ),
  insetAnimationCurve: $enumDecodeNullable(
    _$StCurvesEnumMap,
    json['insetAnimationCurve'],
  ),
  insetPadding: json['insetPadding'] == null
      ? const StacEdgeInsets(left: 40, right: 40, top: 24, bottom: 24)
      : StacEdgeInsets.fromJson(json['insetPadding']),
  clipBehavior: $enumDecodeNullable(_$StacClipEnumMap, json['clipBehavior']),
  shape: json['shape'] == null
      ? null
      : StacShapeBorder.fromJson(json['shape'] as Map<String, dynamic>),
  alignment: $enumDecodeNullable(_$StacAlignmentEnumMap, json['alignment']),
  child: json['child'] == null
      ? null
      : StacWidget.fromJson(json['child'] as Map<String, dynamic>),
  semanticsRole:
      $enumDecodeNullable(_$StSemanticsRoleEnumMap, json['semanticsRole']) ??
      StSemanticsRole.dialog,
  constraints: json['constraints'] == null
      ? null
      : StacBoxConstraints.fromJson(
          json['constraints'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$StDialogToJson(StDialog instance) => <String, dynamic>{
  'backgroundColor': instance.backgroundColor,
  'elevation': instance.elevation,
  'shadowColor': instance.shadowColor,
  'surfaceTintColor': instance.surfaceTintColor,
  'insetAnimationDuration': instance.insetAnimationDuration?.toJson(),
  'insetAnimationCurve': _$StCurvesEnumMap[instance.insetAnimationCurve],
  'insetPadding': instance.insetPadding?.toJson(),
  'clipBehavior': _$StacClipEnumMap[instance.clipBehavior],
  'shape': instance.shape?.toJson(),
  'alignment': _$StacAlignmentEnumMap[instance.alignment],
  'child': instance.child?.toJson(),
  'semanticsRole': _$StSemanticsRoleEnumMap[instance.semanticsRole]!,
  'constraints': instance.constraints?.toJson(),
  'type': instance.type,
};

const _$StCurvesEnumMap = {
  StCurves.bounceIn: 'bounceIn',
  StCurves.bounceInOut: 'bounceInOut',
  StCurves.bounceOut: 'bounceOut',
  StCurves.decelerate: 'decelerate',
  StCurves.ease: 'ease',
  StCurves.easeIn: 'easeIn',
  StCurves.easeInBack: 'easeInBack',
  StCurves.easeInCirc: 'easeInCirc',
  StCurves.easeInCubic: 'easeInCubic',
  StCurves.easeInExpo: 'easeInExpo',
  StCurves.easeInOut: 'easeInOut',
  StCurves.easeInOutBack: 'easeInOutBack',
  StCurves.easeInOutCirc: 'easeInOutCirc',
  StCurves.easeInOutCubic: 'easeInOutCubic',
  StCurves.easeInOutCubicEmphasized: 'easeInOutCubicEmphasized',
  StCurves.easeInOutExpo: 'easeInOutExpo',
  StCurves.easeInOutQuad: 'easeInOutQuad',
  StCurves.easeInOutQuart: 'easeInOutQuart',
  StCurves.easeInOutQuint: 'easeInOutQuint',
  StCurves.easeInOutSine: 'easeInOutSine',
  StCurves.easeInQuad: 'easeInQuad',
  StCurves.easeInQuart: 'easeInQuart',
  StCurves.easeInQuint: 'easeInQuint',
  StCurves.easeInSine: 'easeInSine',
  StCurves.easeInToLinear: 'easeInToLinear',
  StCurves.easeOut: 'easeOut',
  StCurves.easeOutBack: 'easeOutBack',
  StCurves.easeOutCirc: 'easeOutCirc',
  StCurves.easeOutCubic: 'easeOutCubic',
  StCurves.easeOutExpo: 'easeOutExpo',
  StCurves.easeOutQuad: 'easeOutQuad',
  StCurves.easeOutQuart: 'easeOutQuart',
  StCurves.easeOutQuint: 'easeOutQuint',
  StCurves.easeOutSine: 'easeOutSine',
  StCurves.elasticIn: 'elasticIn',
  StCurves.elasticInOut: 'elasticInOut',
  StCurves.elasticOut: 'elasticOut',
  StCurves.fastEaseInToSlowEaseOut: 'fastEaseInToSlowEaseOut',
  StCurves.fastLinearToSlowEaseIn: 'fastLinearToSlowEaseIn',
  StCurves.fastOutSlowIn: 'fastOutSlowIn',
  StCurves.linear: 'linear',
  StCurves.linearToEaseOut: 'linearToEaseOut',
  StCurves.slowMiddle: 'slowMiddle',
};

const _$StacClipEnumMap = {
  StacClip.none: 'none',
  StacClip.hardEdge: 'hardEdge',
  StacClip.antiAlias: 'antiAlias',
  StacClip.antiAliasWithSaveLayer: 'antiAliasWithSaveLayer',
};

const _$StacAlignmentEnumMap = {
  StacAlignment.topLeft: 'topLeft',
  StacAlignment.topCenter: 'topCenter',
  StacAlignment.topRight: 'topRight',
  StacAlignment.centerLeft: 'centerLeft',
  StacAlignment.center: 'center',
  StacAlignment.centerRight: 'centerRight',
  StacAlignment.bottomLeft: 'bottomLeft',
  StacAlignment.bottomCenter: 'bottomCenter',
  StacAlignment.bottomRight: 'bottomRight',
};

const _$StSemanticsRoleEnumMap = {
  StSemanticsRole.none: 'none',
  StSemanticsRole.tab: 'tab',
  StSemanticsRole.tabBar: 'tabBar',
  StSemanticsRole.tabPanel: 'tabPanel',
  StSemanticsRole.dialog: 'dialog',
  StSemanticsRole.alertDialog: 'alertDialog',
  StSemanticsRole.table: 'table',
  StSemanticsRole.cell: 'cell',
  StSemanticsRole.row: 'row',
  StSemanticsRole.columnHeader: 'columnHeader',
  StSemanticsRole.dragHandle: 'dragHandle',
  StSemanticsRole.spinButton: 'spinButton',
  StSemanticsRole.comboBox: 'comboBox',
  StSemanticsRole.menuBar: 'menuBar',
  StSemanticsRole.menu: 'menu',
  StSemanticsRole.menuItem: 'menuItem',
  StSemanticsRole.menuItemCheckbox: 'menuItemCheckbox',
  StSemanticsRole.menuItemRadio: 'menuItemRadio',
  StSemanticsRole.list: 'list',
  StSemanticsRole.listItem: 'listItem',
  StSemanticsRole.form: 'form',
  StSemanticsRole.tooltip: 'tooltip',
  StSemanticsRole.loadingSpinner: 'loadingSpinner',
  StSemanticsRole.progressBar: 'progressBar',
  StSemanticsRole.hotKey: 'hotKey',
  StSemanticsRole.radioGroup: 'radioGroup',
  StSemanticsRole.status: 'status',
  StSemanticsRole.alert: 'alert',
  StSemanticsRole.complementary: 'complementary',
  StSemanticsRole.contentInfo: 'contentInfo',
  StSemanticsRole.main: 'main',
  StSemanticsRole.navigation: 'navigation',
  StSemanticsRole.region: 'region',
};
