import 'dart:ui' show SemanticsRole;

import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import 'package:smoketrees_app_template/enums/st_enums/st_curves.dart';
import 'package:smoketrees_app_template/enums/st_enums/st_semantics_role.dart';

import 'st_dialog.dart';

/// Parser for [StDialog] that maps the Stac model onto Flutter's [Dialog].
class StDialogParser extends StacParser<StDialog> {
  const StDialogParser();

  @override
  String get type => 'dialog';

  @override
  StDialog getModel(Map<String, dynamic> json) => StDialog.fromJson(json);

  @override
  Widget parse(BuildContext context, StDialog model) {
    return Dialog(
      backgroundColor: model.backgroundColor?.toColor(context),
      elevation: model.elevation,
      shadowColor: model.shadowColor?.toColor(context),
      surfaceTintColor: model.surfaceTintColor?.toColor(context),
      insetAnimationDuration:
          model.insetAnimationDuration?.parse ??
          const Duration(milliseconds: 250),
      insetAnimationCurve: _toCurve(model.insetAnimationCurve),
      insetPadding:
          model.insetPadding?.parse ??
          const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      clipBehavior: model.clipBehavior?.parse ?? Clip.none,
      shape: model.shape?.parse(context),
      alignment: model.alignment?.parse,
      semanticsRole: _toSemanticsRole(model.semanticsRole),
      constraints: model.constraints?.parse,
      child: model.child?.parse(context),
    );
  }

  /// Maps the pure-Dart [StCurves] (DSL-safe) back to Flutter's [Curves].
  Curve _toCurve(StCurves? curve) {
    switch (curve) {
      case StCurves.bounceIn:
        return Curves.bounceIn;
      case StCurves.bounceInOut:
        return Curves.bounceInOut;
      case StCurves.bounceOut:
        return Curves.bounceOut;
      case StCurves.decelerate:
        return Curves.decelerate;
      case StCurves.ease:
        return Curves.ease;
      case StCurves.easeIn:
        return Curves.easeIn;
      case StCurves.easeInBack:
        return Curves.easeInBack;
      case StCurves.easeInCirc:
        return Curves.easeInCirc;
      case StCurves.easeInCubic:
        return Curves.easeInCubic;
      case StCurves.easeInExpo:
        return Curves.easeInExpo;
      case StCurves.easeInOut:
        return Curves.easeInOut;
      case StCurves.easeInOutBack:
        return Curves.easeInOutBack;
      case StCurves.easeInOutCirc:
        return Curves.easeInOutCirc;
      case StCurves.easeInOutCubic:
        return Curves.easeInOutCubic;
      case StCurves.easeInOutCubicEmphasized:
        return Curves.easeInOutCubicEmphasized;
      case StCurves.easeInOutExpo:
        return Curves.easeInOutExpo;
      case StCurves.easeInOutQuad:
        return Curves.easeInOutQuad;
      case StCurves.easeInOutQuart:
        return Curves.easeInOutQuart;
      case StCurves.easeInOutQuint:
        return Curves.easeInOutQuint;
      case StCurves.easeInOutSine:
        return Curves.easeInOutSine;
      case StCurves.easeInQuad:
        return Curves.easeInQuad;
      case StCurves.easeInQuart:
        return Curves.easeInQuart;
      case StCurves.easeInQuint:
        return Curves.easeInQuint;
      case StCurves.easeInSine:
        return Curves.easeInSine;
      case StCurves.easeInToLinear:
        return Curves.easeInToLinear;
      case StCurves.easeOut:
        return Curves.easeOut;
      case StCurves.easeOutBack:
        return Curves.easeOutBack;
      case StCurves.easeOutCirc:
        return Curves.easeOutCirc;
      case StCurves.easeOutCubic:
        return Curves.easeOutCubic;
      case StCurves.easeOutExpo:
        return Curves.easeOutExpo;
      case StCurves.easeOutQuad:
        return Curves.easeOutQuad;
      case StCurves.easeOutQuart:
        return Curves.easeOutQuart;
      case StCurves.easeOutQuint:
        return Curves.easeOutQuint;
      case StCurves.easeOutSine:
        return Curves.easeOutSine;
      case StCurves.elasticIn:
        return Curves.elasticIn;
      case StCurves.elasticInOut:
        return Curves.elasticInOut;
      case StCurves.elasticOut:
        return Curves.elasticOut;
      case StCurves.fastEaseInToSlowEaseOut:
        return Curves.fastEaseInToSlowEaseOut;
      case StCurves.fastLinearToSlowEaseIn:
        return Curves.fastLinearToSlowEaseIn;
      case StCurves.fastOutSlowIn:
        return Curves.fastOutSlowIn;
      case StCurves.linear:
        return Curves.linear;
      case StCurves.linearToEaseOut:
        return Curves.linearToEaseOut;
      case StCurves.slowMiddle:
        return Curves.slowMiddle;
      case null:
        return Curves.decelerate;
    }
  }

  /// Maps the pure-Dart [StSemanticsRole] (DSL-safe) back to Flutter's
  /// [SemanticsRole] at render time.
  SemanticsRole _toSemanticsRole(StSemanticsRole role) {
    switch (role) {
      case StSemanticsRole.none:
        return SemanticsRole.none;
      case StSemanticsRole.tab:
        return SemanticsRole.tab;
      case StSemanticsRole.tabBar:
        return SemanticsRole.tabBar;
      case StSemanticsRole.tabPanel:
        return SemanticsRole.tabPanel;
      case StSemanticsRole.dialog:
        return SemanticsRole.dialog;
      case StSemanticsRole.alertDialog:
        return SemanticsRole.alertDialog;
      case StSemanticsRole.table:
        return SemanticsRole.table;
      case StSemanticsRole.cell:
        return SemanticsRole.cell;
      case StSemanticsRole.row:
        return SemanticsRole.row;
      case StSemanticsRole.columnHeader:
        return SemanticsRole.columnHeader;
      case StSemanticsRole.dragHandle:
        return SemanticsRole.dragHandle;
      case StSemanticsRole.spinButton:
        return SemanticsRole.spinButton;
      case StSemanticsRole.comboBox:
        return SemanticsRole.comboBox;
      case StSemanticsRole.menuBar:
        return SemanticsRole.menuBar;
      case StSemanticsRole.menu:
        return SemanticsRole.menu;
      case StSemanticsRole.menuItem:
        return SemanticsRole.menuItem;
      case StSemanticsRole.menuItemCheckbox:
        return SemanticsRole.menuItemCheckbox;
      case StSemanticsRole.menuItemRadio:
        return SemanticsRole.menuItemRadio;
      case StSemanticsRole.list:
        return SemanticsRole.list;
      case StSemanticsRole.listItem:
        return SemanticsRole.listItem;
      case StSemanticsRole.form:
        return SemanticsRole.form;
      case StSemanticsRole.tooltip:
        return SemanticsRole.tooltip;
      case StSemanticsRole.loadingSpinner:
        return SemanticsRole.loadingSpinner;
      case StSemanticsRole.progressBar:
        return SemanticsRole.progressBar;
      case StSemanticsRole.hotKey:
        return SemanticsRole.hotKey;
      case StSemanticsRole.radioGroup:
        return SemanticsRole.radioGroup;
      case StSemanticsRole.status:
        return SemanticsRole.status;
      case StSemanticsRole.alert:
        return SemanticsRole.alert;
      case StSemanticsRole.complementary:
        return SemanticsRole.complementary;
      case StSemanticsRole.contentInfo:
        return SemanticsRole.contentInfo;
      case StSemanticsRole.main:
        return SemanticsRole.main;
      case StSemanticsRole.navigation:
        return SemanticsRole.navigation;
      case StSemanticsRole.region:
        return SemanticsRole.region;
    }
  }
}
