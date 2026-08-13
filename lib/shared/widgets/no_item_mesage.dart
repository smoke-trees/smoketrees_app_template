import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:smoketrees_app_template/theme/colors.dart';

import '../../../utils/assets.dart';
import '../../../utils/utils.dart';

class NoItemMessage extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final Widget? decisionButton;
  const NoItemMessage({
    required this.title,
    this.subTitle,
    this.decisionButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LottieBuilder.asset(AppAssets.shoppingLottie),
          Text(title!, style: Get.textTheme.headlineMedium),
          if (subTitle != null) ...[
            20.h,
            SizedBox(
              width: 250,
              child: Text(
                subTitle!,
                style: Get.textTheme.headlineMedium?.copyWith(
                  fontSize: 14,
                  color: AppColors.grey1,
                ),
              ),
            ),
          ],
          if (decisionButton != null) ...[20.h, decisionButton!],
        ],
      ),
    );
  }
}
