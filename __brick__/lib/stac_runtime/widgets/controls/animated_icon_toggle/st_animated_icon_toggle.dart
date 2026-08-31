import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_animated_icon_toggle.g.dart';

/// Tappable icon that cross-fades/scales between two states via
/// [AnimatedSwitcher], mirroring the original `_CompleteButton`.
///
/// ```json
/// {
///   "type": "animated_icon_toggle",
///   "when": "{{completed}}",
///   "trueIcon": "check_circle_rounded",
///   "falseIcon": "radio_button_unchecked_rounded",
///   "trueColor": "#169AB4",
///   "falseColor": "#9E9E9E",
///   "size": 30,
///   "durationMs": 200,
///   "onTap": { "actionType": "toggle_to_do", "id": "{{id}}" }
/// }
/// ```
@JsonSerializable(explicitToJson: true)
class StAnimatedIconToggle extends StacWidget {
  const StAnimatedIconToggle({
    required this.when,
    required this.trueIcon,
    required this.falseIcon,
    this.trueColor,
    this.falseColor,
    this.size = 24,
    this.durationMs = 200,
    this.onTap,
  });

  final dynamic when;
  final String trueIcon;
  final String falseIcon;
  final StacColor? trueColor;
  final StacColor? falseColor;
  final double size;
  final int durationMs;
  final StacAction? onTap;

  @override
  String get type => 'animated_icon_toggle';

  factory StAnimatedIconToggle.fromJson(Map<String, dynamic> json) =>
      _$StAnimatedIconToggleFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StAnimatedIconToggleToJson(this);
}
