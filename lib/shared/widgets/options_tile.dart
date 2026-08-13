import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smoketrees_app_template/theme/colors.dart';

import '../../../utils/assets.dart';

class OptionsTile extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final void Function()? onTap;
  final Color? textColor;
  final bool? showArrow;
  const OptionsTile({
    super.key,
    required this.title,
    this.subTitle,
    required this.onTap,
    this.textColor = Colors.black,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.grey)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title!,
              style: Get.textTheme.headlineSmall?.copyWith(color: textColor),
            ),
            Row(
              spacing: 12,
              children: [
                subTitle != null
                    ? Text(
                        subTitle!,
                        style: Get.textTheme.headlineSmall?.copyWith(
                          color: AppColors.grey1,
                        ),
                      )
                    : const SizedBox.shrink(),
                if (showArrow!)
                  RotatedBox(
                    quarterTurns: 3,
                    child: SvgPicture.asset(AppAssets.chevronDownArrow),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
