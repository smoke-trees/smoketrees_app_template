import 'package:json_annotation/json_annotation.dart';
import 'package:smoketrees_app_template/enums/st_enums/st_curves.dart';
import 'package:smoketrees_app_template/enums/st_enums/st_semantics_role.dart';
import 'package:stac/stac_core.dart';

part 'st_dialog.g.dart';

@JsonSerializable(explicitToJson: true)
class StDialog extends StacWidget {
  const StDialog({
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.insetAnimationDuration,
    this.insetAnimationCurve,
    this.insetPadding = const StacEdgeInsets(
      left: 40,
      right: 40,
      top: 24,
      bottom: 24,
    ),
    this.clipBehavior,
    this.shape,
    this.alignment,
    this.child,
    this.semanticsRole = StSemanticsRole.dialog,
    this.constraints,
  });

  final StacColor? backgroundColor;
  final double? elevation;
  final StacColor? shadowColor;
  final StacColor? surfaceTintColor;
  final StacDuration? insetAnimationDuration;
  final StCurves? insetAnimationCurve;
  final StacEdgeInsets? insetPadding;
  final StacClip? clipBehavior;
  final StacShapeBorder? shape;
  final StacAlignment? alignment;
  final StacWidget? child;
  final StSemanticsRole semanticsRole;
  final StacBoxConstraints? constraints;

  @override
  String get type => 'dialog';

  factory StDialog.fromJson(Map<String, dynamic> json) =>
      _$StDialogFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StDialogToJson(this);
}
