import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_conditional_widget.g.dart';

@JsonSerializable(explicitToJson: true)
class StConditionalWidget extends StacWidget {
  const StConditionalWidget({
    required this.when,
    this.whenTrue,
    this.whenFalse,
  });

  final dynamic when;
  final StacWidget? whenTrue;
  final StacWidget? whenFalse;

  @override
  String get type => 'st_conditional_widget';

  factory StConditionalWidget.fromJson(Map<String, dynamic> json) =>
      _$StConditionalWidgetFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StConditionalWidgetToJson(this);
}
