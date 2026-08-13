import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/utils.dart';
import 'package:toastification/toastification.dart';

import '../../theme/colors.dart';

class AppSnackBars {
  static customSnackBar({
    required BuildContext context,
    required String message,
    bool isError = false,
  }) {
    toastification.show(
      context: context,
      primaryColor: isError ? AppColors.error : AppColors.success,
      title: Text(message, maxLines: 2),
      style: ToastificationStyle.fillColored,
      foregroundColor: AppColors.white,
      icon: Icon(isError ? Icons.error : Icons.check_circle),
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  static customSnackBar2({
    required BuildContext context,
    String message = "Something went wrong Try again",
    bool isError = false,
    String actionText = "",
    VoidCallback? actionTap,
  }) {
    SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: actionText.isEmpty ? 16 : 0,
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: Get.textTheme.bodyMedium!.copyWith(color: AppColors.textWhite),
      ),
      backgroundColor: isError ? AppColors.error : AppColors.success,
      action: actionText.isNotEmpty
          ? SnackBarAction(
              textColor: AppColors.textWhite,
              label: actionText,
              onPressed: () {
                actionTap?.call();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            )
          : null,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future<void> showSnackBar({
    required BuildContext context,
    String title = "Something went wrong !",
    String message = "Try again",
    bool isError = false,
    String actionText = "",
    Duration duration = const Duration(seconds: 2),
    VoidCallback? actionTap,
    EdgeInsets margin = const EdgeInsets.symmetric(
      horizontal: 10,

      ///previously vertical: 100,
      vertical: 0,
    ),
  }) async {
    SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: duration,
      margin: margin,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: actionText.isEmpty ? 16 : 0,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.start,
            style: Get.textTheme.headlineMedium!.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w700,
            ),
          ),
          3.h,
          Text(
            message,
            textAlign: TextAlign.start,
            style: Get.textTheme.titleMedium!.copyWith(color: AppColors.error),
          ),
        ],
      ),
      backgroundColor: isError ? AppColors.errorBg : AppColors.warningBg,
      action: actionText.isNotEmpty
          ? SnackBarAction(
              textColor: AppColors.error,
              label: actionText,
              onPressed: () {
                actionTap?.call();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            )
          : null,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
