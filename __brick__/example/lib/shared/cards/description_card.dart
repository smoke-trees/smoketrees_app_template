import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:{{project_name}}/theme/colors.dart';

import '../../utils/utils.dart';
import '../widgets/html_text.dart';

class DescriptionCard extends StatelessWidget {
  const DescriptionCard({Key? key, this.name, this.description})
    : super(key: key);

  final String? name;
  final String? description;

  @override
  Widget build(BuildContext context) {
    if (name == null && description == null) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      clipBehavior: Clip.antiAlias,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (name != null && (name?.isNotEmpty ?? false)) ...[
            Text(
              name ?? '',
              style: Get.textTheme.bodyLarge!.copyWith(color: AppColors.dark),
            ),
            10.h,
          ],
          if (description != null && (description?.isNotEmpty ?? false)) ...[
            if (description != "<p>-</p>")
              HtmlText(
                text: description ?? '', // showCustomStyle: true,
              ),
          ],
        ],
      ),
    );
  }
}
