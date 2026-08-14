import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../utils/assets.dart';

class ProductsLoading extends StatelessWidget {
  final String? title;
  const ProductsLoading({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LottieBuilder.asset(AppAssets.diamondLoading),
          Text(title!, style: Get.textTheme.headlineSmall),
        ],
      ),
    );
  }
}
