import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smoketrees_app_template/theme/colors.dart';

import '../../../utils/assets.dart';
import '../../../utils/utils.dart';

class MainArrowButton extends StatefulWidget {
  final Function() onTap;
  final String? title;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final bool disabled;
  final bool showLoader;
  final bool isOutlined;
  final double borderRadius;
  final Color color;
  final Color textColor;
  final double? width;
  final Color arrowColor;
  final BorderSide? borderSide;
  final Color? loadingColor;

  const MainArrowButton({
    Key? key,
    required this.onTap,
    this.disabled = false,
    this.showLoader = false,
    this.isOutlined = false,
    this.title,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(vertical: 15),
    this.borderRadius = 30,
    this.color = Colors.black,
    this.textColor = AppColors.white,
    this.width,
    this.arrowColor = Colors.white,
    this.borderSide,
    this.loadingColor = AppColors.white,
  }) : super(key: key);

  @override
  _MainArrowButtonState createState() => _MainArrowButtonState();
}

class _MainArrowButtonState extends State<MainArrowButton> {
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
                if (!isLoadingButton.value) {
                  isLoadingButton.value = true;
                  await widget.onTap();
                  isLoadingButton.value = false;
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
            padding: 40.hp,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title ?? '',
                  style:
                      widget.textStyle ??
                      Get.textTheme.bodyLarge?.copyWith(
                        color: widget.isOutlined
                            ? widget.color
                            : widget.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                widget.showLoader
                    ? Obx(
                        () => !isLoadingButton.value
                            ? SvgPicture.asset(
                                AppAssets.rightArrow,
                                color: widget.arrowColor,
                              )
                            : SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: widget.loadingColor,
                                  strokeCap: StrokeCap.round,
                                  // strokeWidth: 2,
                                ),
                              ),
                      )
                    : SvgPicture.asset(
                        AppAssets.rightArrow,
                        color: widget.arrowColor,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
