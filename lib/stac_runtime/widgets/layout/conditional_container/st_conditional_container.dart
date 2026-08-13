import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_conditional_container.g.dart';

/// Drop-in replacement for [StacContainer] wherever the decoration needs
/// to switch based on a resolved field value. Every other field mirrors
/// [StacContainer] exactly and is passed straight through unchanged.
///
/// ```json
/// {
///   "type": "conditional_container",
///   "width": 44,
///   "height": 44,
///   "when": "{{completed}}",
///   "decorationWhenTrue": { "shape": "circle", "color": "#9E9E9E66" },
///   "decorationWhenFalse": { "shape": "circle", "gradient": {...} },
///   "child": { "type": "center", "...": "..." }
/// }
/// ```
@JsonSerializable(explicitToJson: true)
class StConditionalContainer extends StacWidget {
  const StConditionalContainer({
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.alignment,
    required this.when,
    this.decorationWhenTrue,
    this.decorationWhenFalse,
    this.child,
  });

  final double? width;
  final double? height;
  final StacEdgeInsets? padding;
  final StacEdgeInsets? margin;
  final StacAlignment?
  alignment; // matches StacContainer's alignment field/type

  final dynamic when;
  final StacBoxDecoration? decorationWhenTrue;
  final StacBoxDecoration? decorationWhenFalse;

  final StacWidget? child;

  @override
  String get type => 'conditional_container';

  factory StConditionalContainer.fromJson(Map<String, dynamic> json) =>
      _$StConditionalContainerFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StConditionalContainerToJson(this);
}
