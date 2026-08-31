import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'colors.dart';

InputDecoration filledInputDecoration({
  String? hintText,
  String? labelText,
  double? hintSize = 16,
  double? labelSize = 16,
  bool isDisabled = false,
  bool isDate = false,
  Widget? prefix,
  Widget? prefixIcon,
  Widget? suffix,
  Widget? suffixIcon,
  BorderRadius? borderRadius,
  Color? borderColor,
  Color? fillColor,
}) {
  return InputDecoration(
    isDense: true,
    hintText: hintText,
    prefixIcon: prefixIcon,
    contentPadding: const EdgeInsets.all(16),
    suffixIcon: suffixIcon,
    prefix: prefix,
    suffix: suffix,
    alignLabelWithHint: true,
    labelText: labelText,
    border: OutlineInputBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      borderSide: BorderSide(color: borderColor ?? const Color(0xffE2E2E2)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      borderSide: BorderSide(color: borderColor ?? const Color(0xffE2E2E2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      borderSide: BorderSide(color: borderColor ?? const Color(0xffE2E2E2)),
    ),
    hintStyle: Get.textTheme.bodyMedium?.copyWith(
      color: const Color(0xff595D62),
      fontSize: hintSize,
      fontWeight: FontWeight.w400,
    ),
    labelStyle: Get.textTheme.bodyMedium?.copyWith(
      color: const Color(0xff595D62),
      fontSize: labelSize,
      fontWeight: FontWeight.w400,
    ),
    fillColor: isDisabled
        ? Colors.white12.withValues(alpha: 0.5)
        : fillColor ?? Colors.transparent,
    filled: true,
  );
}

commonInputDecoration({
  String? labelText,
  String? hintText,
  Widget? prefix,
  Widget? suffix,
  Widget? suffixIcon,
  bool isFilled = true,
  bool enabled = true,
  bool showLabel = false,
}) {
  return InputDecoration(
    // contentPadding: EdgeInsets.zero,
    // alignLabelWithHint: true,/
    contentPadding: const EdgeInsets.only(bottom: 10),
    labelText: showLabel ? labelText : null,
    labelStyle: Get.textTheme.bodyLarge?.copyWith(
      fontSize: 14,
      color: AppColors.grey,
    ),

    suffix: suffix,
    suffixIcon: suffixIcon,
    suffixIconConstraints: const BoxConstraints(maxHeight: 16),
    suffixStyle: const TextStyle(fontSize: 16),
    // constraints: BoxConstraints(
    //   maxHeight: 32,
    // ),
    isDense: true,
    isCollapsed: false,
    hintText: hintText,

    hintStyle: Get.textTheme.bodyMedium?.copyWith(
      fontSize: 14,
      color: AppColors.grey,
    ),
    focusColor: AppColors.grey2,
    focusedBorder: AppDecorations.underlineInputBorder,
    enabledBorder: AppDecorations.underlineInputBorder,
    fillColor: AppColors.white,
    errorBorder: AppDecorations.underlineInputBorder.copyWith(
      borderSide: const BorderSide(width: 1, color: AppColors.error),
    ),
    filled: isFilled,
  );
}

class AppDecorations {
  static UnderlineInputBorder get underlineInputBorder =>
      const UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: AppColors.grey1),
      );

  static OutlineInputBorder get filledInputDecoration => OutlineInputBorder(
    borderSide: const BorderSide(width: 0, color: AppColors.iconTextColor),
    borderRadius: BorderRadius.circular(16),
  );

  static OutlineInputBorder get outlineInputDecoration => OutlineInputBorder(
    borderSide: const BorderSide(width: 1.2, color: AppColors.iconTextColor),
    borderRadius: BorderRadius.circular(12),
  );

  static OutlineInputBorder get outlineInputDecorationBlue =>
      OutlineInputBorder(
        borderSide: const BorderSide(width: 1.2, color: AppColors.primaryLight),
        borderRadius: BorderRadius.circular(12),
      );

  static TextStyle get hintTextStyle => Get.textTheme.bodyMedium!.copyWith(
    color: AppColors.dark.withValues(alpha: 0.5),
  );

  static EdgeInsets get textFieldPadding =>
      const EdgeInsets.symmetric(horizontal: 20, vertical: 16);

  static TextStyle get textFieldStyle =>
      Get.textTheme.bodyLarge!.copyWith(color: AppColors.textDark);
}
