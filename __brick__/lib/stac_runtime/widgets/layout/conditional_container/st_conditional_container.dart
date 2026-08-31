import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_conditional_container.g.dart';

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
  final StacAlignment? alignment;

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
