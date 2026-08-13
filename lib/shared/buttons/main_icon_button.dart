import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smoketrees_app_template/theme/colors.dart';

import '../../../utils/utils.dart';

class MainIconButton extends StatefulWidget {
  final Function() onTap;
  final String? title;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final bool disabled;
  final bool showLoader;
  final bool isOutlined;
  final double borderRadius;
  final Color color;
  final Color? loadingColor;
  final Color textColor;
  final double? width;
  final Widget? icon;

  final BorderSide? borderSide;

  const MainIconButton({
    Key? key,
    required this.onTap,
    this.disabled = false,
    this.showLoader = false,
    this.isOutlined = false,
    this.title,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(vertical: 15),
    this.borderRadius = 12,
    this.color = AppColors.primaryColor,
    this.textColor = AppColors.white,
    this.width,
    this.loadingColor = Colors.white,
    this.borderSide,
    this.icon,
  }) : super(key: key);

  @override
  _MainIconButtonState createState() => _MainIconButtonState();
}

class _MainIconButtonState extends State<MainIconButton> {
  RxBool isLoadingButton = false.obs;
  @override
  Widget build(BuildContext context) {
    Color color = widget.isOutlined ? widget.textColor : widget.color;
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
                    color: widget.color,
                    width: widget.isOutlined ? 1 : 0,
                  ),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
          child: Padding(
            padding: 20.hp,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.icon != null
                    ? SizedBox(height: 24, width: 24, child: widget.icon)
                    : const SizedBox.shrink(),
                widget.showLoader
                    ? Obx(
                        () => !isLoadingButton.value
                            ? Text(
                                widget.title ?? '',
                                style:
                                    widget.textStyle ??
                                    Get.textTheme.bodyMedium?.copyWith(
                                      color: widget.isOutlined
                                          ? widget.color
                                          : widget.textColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                              )
                            : SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: widget.loadingColor,
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                      )
                    : Text(
                        widget.title ?? '',
                        style:
                            widget.textStyle ??
                            Get.textTheme.bodyMedium?.copyWith(
                              color: widget.isOutlined
                                  ? widget.color
                                  : widget.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
