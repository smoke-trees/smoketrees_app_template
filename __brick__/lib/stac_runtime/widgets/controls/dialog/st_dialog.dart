import 'package:json_annotation/json_annotation.dart';
import 'package:{{project_name}}/enums/st_enums/st_curves.dart';
import 'package:{{project_name}}/enums/st_enums/st_semantics_role.dart';
import 'package:stac/stac_core.dart';

part 'st_dialog.g.dart';

/// A Stac model representing Flutter's [Dialog] widget.
///
/// A generic Material Design dialog surface. Unlike `alertDialog`, [StDialog]
/// gives you a single [child] slot so you can compose any layout inside the
/// dialog surface while still controlling the surrounding shape, color,
/// elevation and inset behaviour.
///
/// ```json
/// {
///   "type": "dialog",
///   "backgroundColor": "#FFFFFF",
///   "elevation": 8,
///   "insetPadding": { "left": 24, "right": 24, "top": 24, "bottom": 24 },
///   "shape": {
///     "type": "roundedRectangleBorder",
///     "borderRadius": { "all": 16 }
///   },
///   "alignment": "center",
///   "clipBehavior": "antiAlias",
///   "child": {
///     "type": "padding",
///     "padding": { "left": 20, "top": 20, "right": 20, "bottom": 20 },
///     "child": { "type": "text", "data": "Hello from a custom dialog" }
///   }
/// }
/// ```
///
/// See also:
///  * Flutter's [Dialog documentation](https://api.flutter.dev/flutter/material/Dialog-class.html)
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

  /// The background color of the dialog's [Material].
  final StacColor? backgroundColor;

  /// The z-coordinate of this dialog relative to its parent.
  final double? elevation;

  /// The color used to paint a drop shadow under the dialog.
  final StacColor? shadowColor;

  /// The color used as a surface tint overlay on the dialog's background.
  final StacColor? surfaceTintColor;

  /// The duration of the animation to show when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  final StacDuration? insetAnimationDuration;

  /// The curve to use for the animation shown when the system keyboard intrudes
  /// into the space that the dialog is placed in.
  ///
  /// Accepts a curve name such as `linear`, `decelerate`, `ease`, `easeIn`,
  /// `easeOut`, `easeInOut`, `fastOutSlowIn`, `bounceIn`, `bounceOut`,
  /// `elasticIn` or `elasticOut`.
  final StCurves? insetAnimationCurve;

  /// The amount of padding added around the dialog's outer edges.
  final StacEdgeInsets? insetPadding;

  /// How to clip the [child]'s content.
  final StacClip? clipBehavior;

  /// The shape of this dialog's border.
  final StacShapeBorder? shape;

  /// How to align the dialog within its parent.
  final StacAlignment? alignment;

  /// The widget below this dialog in the tree.
  final StacWidget? child;

  /// The role this dialog represents to assistive technologies.
  ///
  /// Defaults to [StSemanticsRole.dialog].
  final StSemanticsRole semanticsRole;

  /// Constrains the size of the dialog.
  /// If null, then [DialogThemeData.constraints] is used. If that is also null,
  /// defaults to [BoxConstraints.loose].
  final StacBoxConstraints? constraints;

  @override
  String get type => 'dialog';

  factory StDialog.fromJson(Map<String, dynamic> json) =>
      _$StDialogFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StDialogToJson(this);
}
