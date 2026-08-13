import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smoketrees_app_template/theme/colors.dart';

class TextShimmer extends StatelessWidget {
  final double width;
  final double height;
  final Color baseColor;
  final Color highlightColor;
  const TextShimmer({
    Key? key,
    required this.width,
    required this.height,
    this.baseColor = AppColors.grey,
    this.highlightColor = AppColors.grey2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.grey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        width: width,
        height: height,
      ),
    );
  }
}
