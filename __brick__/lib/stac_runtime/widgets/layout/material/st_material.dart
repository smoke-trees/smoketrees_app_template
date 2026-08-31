import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_material.g.dart';

/// Stac-native mirror of Flutter's [MaterialType], kept in pure Dart so
/// `stac/` DSL screens that reference `StMaterial` stay free of any
/// Flutter (`dart:ui`) dependency and can be compiled by the Stac CLI.
///
/// The Flutter `StMaterialParser` maps this back to [MaterialType] at render
/// time.
enum StacMaterialType { canvas, card, circle, button, transparency }

/// Data model for the `"material"` Stac widget type.
///
/// Mirrors Flutter's [Material] widget so it can be driven entirely from
/// server-delivered JSON. Every field uses the same Stac-native types the
/// rest of stac_core's DSL widgets use (StacColor, StacBorderRadius,
/// StacClip, StacTextStyle, StacDuration, StacWidget) instead of raw
/// strings/primitives, so it serializes/deserializes and themes the same
/// way as built-in widgets like StacContainer or StacClipRRect.
@JsonSerializable(explicitToJson: true)
class StMaterial extends StacWidget {
  const StMaterial({
    this.materialType = StacMaterialType.canvas,
    this.elevation = 0.0,
    this.color,
    this.shadowColor,
    this.surfaceTintColor,
    this.textStyle,
    this.borderRadius,
    this.borderOnForeground = true,
    this.clipBehavior = StacClip.none,
    this.animationDuration = const StacDuration(milliseconds: 200),
    this.child,
  });

  /// Maps to [Material.type]. Uses the pure-Dart [StacMaterialType] enum
  /// (canvas, card, circle, button, transparency) — serialized as a plain
  /// string by json_serializable, then mapped back to Flutter's
  /// [MaterialType] by `StMaterialParser` at render time.
  final StacMaterialType materialType;

  /// Maps to [Material.elevation]. Must be >= 0.
  final double elevation;

  /// Maps to [Material.color].
  final StacColor? color;

  /// Maps to [Material.shadowColor].
  final StacColor? shadowColor;

  /// Maps to [Material.surfaceTintColor].
  final StacColor? surfaceTintColor;

  /// Maps to [Material.textStyle], applied to descendant text.
  final StacTextStyle? textStyle;

  /// Maps to [Material.borderRadius]. Supports `StacBorderRadius.all()`,
  /// `.only()`, or the full four-corner constructor, same as
  /// StacClipRRect's borderRadius.
  final StacBorderRadius? borderRadius;

  /// Maps to [Material.borderOnForeground].
  final bool borderOnForeground;

  /// Maps to [Material.clipBehavior]. Same enum used by StacContainer,
  /// StacStack, StacClipRRect, etc.
  final StacClip clipBehavior;

  /// Maps to [Material.animationDuration].
  final StacDuration animationDuration;

  /// Maps to [Material.child]. Resolved recursively by Stac like any other
  /// nested widget.
  final StacWidget? child;

  @override
  String get type => 'st_material';

  factory StMaterial.fromJson(Map<String, dynamic> json) =>
      _$StMaterialFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StMaterialToJson(this);
}