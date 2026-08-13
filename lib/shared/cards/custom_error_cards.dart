import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/utils.dart';

import '../../theme/colors.dart';
import '../../features/splash/splash_page.dart';

class CustomErrorCard extends StatelessWidget {
  const CustomErrorCard({
    super.key,
    required this.error,
    this.showRefreshButton = false,
  });

  final String error;

  final bool showRefreshButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        width: Get.width * 0.9,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              !kDebugMode
                  ? "Error: $error"
                  : !showRefreshButton
                  ? "Something went wrong, please try agin later"
                  : "Please check your internet connection or refresh the page. If the issue continues, feel free to contact our support team.",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            if (showRefreshButton) ...[
              8.h,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dark,
                ),
                onPressed: () {
                  Get.offAllNamed(SplashPage.routeName);
                },
                child: const Text(
                  'Refresh Page',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
