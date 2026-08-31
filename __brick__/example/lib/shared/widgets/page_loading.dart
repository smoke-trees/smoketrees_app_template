import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:{{project_name}}/theme/colors.dart';

import '../../utils/utils.dart';

class PageLoading extends StatelessWidget {
  const PageLoading({Key? key, this.text = "  Loading..."}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          20.h,
          Text(
            text,
            style: Get.textTheme.bodyLarge?.copyWith(
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
