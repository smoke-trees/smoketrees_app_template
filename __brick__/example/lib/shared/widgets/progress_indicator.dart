import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:{{project_name}}/theme/colors.dart';

class ProgressView extends StatelessWidget {
  const ProgressView({
    super.key,
    required this.progress,
    required this.size,
    this.textStyle,
    this.valueColor = AppColors.l1,
    this.backgroundColor,
    this.strokeWidth = 8,
  });

  final double progress;
  final double size;
  final TextStyle? textStyle;
  final Color valueColor;
  final Color? backgroundColor;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: size,
          width: size,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: strokeWidth,
            backgroundColor:
                backgroundColor ?? Colors.grey.withValues(alpha: 0.5),
            valueColor: AlwaysStoppedAnimation<Color>(valueColor),
          ),
        ),
        AutoSizeText(
          '${(progress * 100).round()}%',
          style:
              textStyle ??
              Get.textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
