import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_animated_container.g.dart';

/// Generic [AnimatedContainer] wrapper â€” animates decoration/size/padding
/// changes over [durationMs] whenever the resolved field values change
/// (e.g. after a list refresh swaps in a new `completed` value).
///
/// ```json
/// {
///   "type": "animated_container",
///   "durationMs": 200,
///   "width": 300,
///   "padding": { "left": 16, "top": 16, "right": 16, "bottom": 16 },
///   "alignment": "center",
///   "decoration": {
///     "color": "#FFFFFF",
///     "borderRadius": 18,
///     "border": { "color": "#E0E0E0", "width": 1 },
///     "boxShadow": [ { "color": "#0000000D", "blurRadius": 16, "offset": { "dx": 0, "dy": 6 } } ]
///   },
///   "child": { "type": "padding", "...": "..." }
/// }
/// ```
@JsonSerializable(explicitToJson: true)
class StAnimatedContainer extends StacWidget {
  const StAnimatedContainer({
    this.durationMs = 200,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.alignment,
    this.decoration,
    this.decorationWhen, // NEW
    this.decorationWhenTrue, // NEW
    this.decorationWhenFalse, // NEW
    this.child,
  });

  final int durationMs;
  final double? width;
  final double? height;
  final StacEdgeInsets? padding;
  final StacEdgeInsets? margin;
  final String? alignment;

  /// Static decoration, used when [decorationWhen] is not provided.
  final StacBoxDecoration? decoration;

  /// If set, [decorationWhenTrue]/[decorationWhenFalse] are picked based on
  /// this value instead of using [decoration]. Pass a field reference like
  /// `"{{completed}}"`.
  final dynamic decorationWhen;
  final StacBoxDecoration? decorationWhenTrue;
  final StacBoxDecoration? decorationWhenFalse;

  final StacWidget? child;

  @override
  String get type => 'animated_container';

  factory StAnimatedContainer.fromJson(Map<String, dynamic> json) =>
      _$StAnimatedContainerFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StAnimatedContainerToJson(this);
}
