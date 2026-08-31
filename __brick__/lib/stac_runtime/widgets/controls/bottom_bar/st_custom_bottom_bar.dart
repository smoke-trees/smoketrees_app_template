import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_custom_bottom_bar.g.dart';

@JsonSerializable()
class StCustomBottomBar extends StacWidget {
  final List<String> labels;
  final List<String> svgIcons;
  final List<String> svgFilledIcons;
  final int?
  specialIndex; // optional index (e.g. 3) that gets the special stacked treatment

  const StCustomBottomBar({
    required this.labels,
    required this.svgIcons,
    required this.svgFilledIcons,
    this.specialIndex,
  });

  @override
  String get type => 'custom_bottom_bar';

  factory StCustomBottomBar.fromJson(Map<String, dynamic> json) =>
      _$StCustomBottomBarFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StCustomBottomBarToJson(this);
}
