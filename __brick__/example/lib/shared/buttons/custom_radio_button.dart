import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:{{project_name}}/theme/colors.dart';

class CustomRadioButton extends StatelessWidget {
  final bool value;
  final String? title;
  final Function() onChanged;
  final double? fontSize;
  final double? size;
  final Color? fillColor;
  final Color? selectColor;
  final bool expandedTitle;
  final bool isDisabled;

  const CustomRadioButton({
    super.key,
    required this.value,
    this.title,
    required this.onChanged,
    this.fontSize,
    this.size = 20,
    this.fillColor,
    this.selectColor = const Color(0xff4E46B4),
    this.expandedTitle = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: isDisabled ? null : () => onChanged(),
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            spacing: 10,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: value ? selectColor! : AppColors.textDark,
                        width: 1,
                      ),
                      shape: BoxShape.circle,
                      color: fillColor ?? AppColors.transparent,
                    ),
                  ),
                  value
                      ? Container(
                          width: size! * 0.4,
                          height: size! * 0.4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectColor!,
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              if (title != null)
                expandedTitle
                    ? Expanded(
                        child: Text(
                          title ?? '',
                          style: Get.textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: fontSize ?? 16,
                            color: AppColors.textDark,
                          ),
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : Text(
                        title ?? '',
                        style: Get.textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: fontSize ?? 16,
                          color: AppColors.textDark,
                        ),
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
            ],
          ),
        ),
      ),
    );
  }
}
