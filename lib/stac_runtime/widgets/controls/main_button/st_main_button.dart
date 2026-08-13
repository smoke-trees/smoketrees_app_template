import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'st_main_button.g.dart';

@JsonSerializable()
class StMainButton extends StacWidget {
  final String? actionKey; // legacy â€” prefer onPressed for new screens
  final StacAction? onPressed;
  final String? title;
  final StacTextStyle? textStyle;
  final StacEdgeInsets padding;
  final bool disabled;
  final bool showLoader;
  final bool isOutlined;
  final double borderRadius;
  final StacColor? color;
  final StacColor? textColor;
  final double? width;
  final double? fontSize;
  final StacColor? loadingColor;
  final StacBorderSide? borderSide;

  const StMainButton({
    this.actionKey,
    this.onPressed,
    this.disabled = false,
    this.showLoader = false,
    this.isOutlined = false,
    this.title,
    this.textStyle,
    this.padding = const StacEdgeInsets.symmetric(vertical: 15),
    this.borderRadius = 30,
    this.color,
    this.textColor,
    this.width,
    this.borderSide,
    this.loadingColor = StacColors.white,
    this.fontSize,
  });

  @override
  String get type => 'main_button';

  factory StMainButton.fromJson(Map<String, dynamic> json) =>
      _$StMainButtonFromJson(json);

  Map<String, dynamic> toJson() => _$StMainButtonToJson(this);
}
