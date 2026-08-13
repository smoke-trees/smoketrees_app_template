import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smoketrees_app_template/theme/colors.dart';

import '../../../utils/utils.dart';

class CustomToggleButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  final bool isSelected;
  final TextStyle? textStyle;
  final double? size;
  final Color? toggleColor;

  const CustomToggleButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.isSelected,
    this.textStyle,
    this.size = 20,
    this.toggleColor = const Color(0xff4E46B4),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: size! * 2,
            height: size! + 2,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: isSelected ? toggleColor : AppColors.grey,
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: isSelected
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                width: size! * 0.8,
                height: size! * 0.8,
                decoration: BoxDecoration(
                  boxShadow: isSelected
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 6),
                          ),
                        ],
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          10.w,
          Flexible(
            child: Text(
              title,
              softWrap: true,
              style:
                  textStyle ??
                  Get.textTheme.bodyMedium!.copyWith(
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
