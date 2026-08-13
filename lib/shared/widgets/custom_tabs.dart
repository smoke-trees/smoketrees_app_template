import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smoketrees_app_template/theme/colors.dart';

import '../../../utils/assets.dart';
import '../../../utils/utils.dart';

class CustomTabs extends StatelessWidget {
  const CustomTabs({Key? key, this.onChange, this.activeIndex = 0})
    : super(key: key);

  final ValueChanged<int>? onChange;
  final int activeIndex;

  static const List<String> titles = [
    "All",
    "In Progress",
    "Not Started",
    "Completed",
  ];

  static const List<String> icons = [
    AppAssets.tabBook,
    AppAssets.tabProgress,
    AppAssets.tabNotStarted,
    AppAssets.tabCompleted,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            children: List.generate(titles.length, (index) => buildTab(index)),
          ),
        ],
      ),
    );
  }

  buildTab(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: InkWell(
        onTap: () {
          if (onChange != null) {
            onChange!(index);
          }
        },
        borderRadius: BorderRadius.circular(38),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          decoration: BoxDecoration(
            color: activeIndex == index
                ? AppColors.primaryColor
                : AppColors.white,
            borderRadius: BorderRadius.circular(38),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                icons[index],
                height: 12,
                color: activeIndex == index
                    ? AppColors.white
                    : AppColors.primaryColor,
                width: 12,
              ),
              5.w,
              Text(
                titles[index],
                style: Get.textTheme.titleMedium?.copyWith(
                  color: activeIndex == index
                      ? AppColors.white
                      : AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
