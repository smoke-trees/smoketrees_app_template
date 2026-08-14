import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smoketrees_app_template/theme/colors.dart';

class MainButton extends StatefulWidget {
  final Function() onTap;
  final String? title;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final bool disabled;
  final bool showLoader;
  final bool isOutlined;
  final double borderRadius;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? fontSize;
  final Color? loadingColor;
  final BorderSide? borderSide;

  const MainButton({
    Key? key,
    required this.onTap,
    this.disabled = false,
    this.showLoader = false,
    this.isOutlined = false,
    this.title,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(vertical: 15),
    this.borderRadius = 30,
    this.color,
    this.textColor,
    this.width,
    this.borderSide,
    this.loadingColor = Colors.white,
    this.fontSize,
  }) : super(key: key);

  @override
  _MainButtonState createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  RxBool isLoadingButton = false.obs;
  @override
  Widget build(BuildContext context) {
    Color color = widget.isOutlined
        ? widget.textColor ?? AppColors.white
        : widget.color ?? Colors.black;
    if (widget.disabled) {
      color = AppColors.dark.withValues(alpha: 0.4);
    }
    return Material(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      color: color,
      child: InkWell(
        onTap: widget.disabled
            ? null
            : () async {
                if (widget.showLoader) {
                  if (!isLoadingButton.value) {
                    isLoadingButton.value = true;
                    await widget.onTap();
                    isLoadingButton.value = false;
                  }
                } else {
                  widget.onTap();
                }
              },
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Container(
          alignment: Alignment.center,
          width: widget.width,
          padding: widget.padding,
          decoration: ShapeDecoration(
            color: color,
            shape: RoundedRectangleBorder(
              side:
                  widget.borderSide ??
                  BorderSide(
                    color: widget.color ?? Colors.black,
                    width: widget.isOutlined ? 1 : 0,
                  ),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
          child: widget.showLoader
              ? Obx(
                  () => !isLoadingButton.value
                      ? Text(
                          widget.title ?? '',
                          style:
                              widget.textStyle ??
                              Get.textTheme.bodyLarge?.copyWith(
                                color: widget.isOutlined
                                    ? widget.color ?? Colors.black
                                    : widget.textColor ?? AppColors.textWhite,
                                fontSize: widget.fontSize ?? 16,
                              ),
                        )
                      : SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            color: widget.loadingColor,
                            strokeCap: StrokeCap.round,
                            // strokeWidth: 2,
                          ),
                        ),
                )
              : Text(
                  widget.title ?? '',
                  style:
                      widget.textStyle ??
                      Get.textTheme.bodyLarge?.copyWith(
                        color: widget.isOutlined
                            ? widget.color ?? Colors.black
                            : widget.textColor ?? AppColors.textWhite,
                        fontSize: widget.fontSize ?? 16,
                      ),
                ),
        ),
      ),
    );
  }
}
