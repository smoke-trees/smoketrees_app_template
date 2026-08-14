import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smoketrees_app_template/theme/colors.dart';

import '../../utils/assets.dart';
import '../../utils/utils.dart';

class ExpandedTile extends StatelessWidget {
  ExpandedTile({
    super.key,
    this.icon,
    this.content,
    required this.title,
    this.subTitle,
  });
  final Widget? icon;
  final Widget? content;
  final String? title;
  final String? subTitle;

  RxBool isExpanded = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: 16.hp,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                isExpanded.value = !isExpanded.value;
              },
              child: Padding(
                padding: 16.vp,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (icon != null) ...[icon!, 8.w],
                          Expanded(
                            child: Text(
                              title!,
                              style: Get.textTheme.bodyMedium?.copyWith(
                                fontSize: 18,
                              ),
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Transform.flip(
                      flipY: isExpanded.value,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 8,
                        ),
                        child: SvgPicture.asset(AppAssets.chevronDownArrow),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (subTitle != null && subTitle!.isNotEmpty) ...[
              4.h,
              Text(
                subTitle!,
                style: Get.textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  color: AppColors.grey1,
                ),
              ),
            ],
            if (isExpanded.value && content != null)
              ...[16.h, content!].fadeInAnimation(
                interval: 0.1,
                delay: 0.5,
                reverse: !isExpanded.value,
              ),
          ],
        ),
      ),
    );
  }
}
