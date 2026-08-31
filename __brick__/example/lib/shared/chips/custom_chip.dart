import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:{{project_name}}/theme/colors.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({Key? key, required this.text, required this.isSelected})
    : super(key: key);
  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: isSelected ? Colors.black : const Color(0xfff5f5f5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: Get.textTheme.bodyMedium?.copyWith(
          color: isSelected ? Colors.white : AppColors.textDark,
          fontSize: 12,
        ),
      ),
    );
  }
}
