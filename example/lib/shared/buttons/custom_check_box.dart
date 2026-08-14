import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smoketrees_app_template/theme/colors.dart';

import '../../utils/utils.dart';

class CustomCheckBox extends StatelessWidget {
  final String title;
  final Function() onTap;
  final bool isSelected;
  final bool invalid;
  final double? fontSize;
  final double? size;
  final TextStyle? textStyle;
  final Color? fillColor;
  final String? invalidText;

  const CustomCheckBox({
    super.key,
    required this.title,
    required this.onTap,
    required this.isSelected,
    this.invalid = false,
    this.fontSize,
    this.size = 20,
    this.textStyle,
    this.fillColor = const Color(0xff4E46B4),
    this.invalidText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: invalid ? () {} : onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: size,
            width: size,
            // padding: 5.p,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(
                  color: invalid
                      ? AppColors.error
                      : isSelected
                      ? fillColor!
                      : AppColors.grey1,
                  width: 2,
                ),
              ),
              color: invalid
                  ? AppColors.error
                  : isSelected
                  ? fillColor
                  : AppColors.white,
            ),
            child: invalid
                ? Align(
                    alignment: Alignment.center,
                    child: Transform.rotate(
                      angle: pi / 4,
                      child: Icon(
                        Icons.add_rounded,
                        size: size! * 0.8,
                        color: AppColors.white,
                      ),
                    ),
                  )
                : isSelected
                ? Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.check_rounded,
                      size: size! * 0.8,
                      color: AppColors.white,
                    ),
                  )
                : null,
          ),
          10.w,
          Flexible(
            flex: 1,
            // width: Get.width * 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style:
                      textStyle?.copyWith(
                        color: invalid ? AppColors.error : null,
                      ) ??
                      Get.textTheme.bodyMedium!.copyWith(
                        fontSize: fontSize ?? 14,
                        color: invalid ? AppColors.error : Colors.black,
                      ),
                ),
                if (invalid)
                  Text(
                    invalidText ?? 'Invalid',
                    style: Get.textTheme.titleMedium?.copyWith(
                      color: invalid ? AppColors.error : null,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
