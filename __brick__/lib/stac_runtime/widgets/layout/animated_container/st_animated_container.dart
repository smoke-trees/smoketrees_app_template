import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_animated_container.g.dart';

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
    this.decorationWhen,
    this.decorationWhenTrue,
    this.decorationWhenFalse,
    this.child,
  });

  final int durationMs;
  final double? width;
  final double? height;
  final StacEdgeInsets? padding;
  final StacEdgeInsets? margin;
  final String? alignment;

  final StacBoxDecoration? decoration;
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
