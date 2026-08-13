import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smoketrees_app_template/theme/colors.dart';

class SectionHeader extends StatefulWidget {
  const SectionHeader({
    Key? key,
    required this.title,
    this.onViewAllTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
  }) : super(key: key);

  final String title;
  final VoidCallback? onViewAllTap;
  final EdgeInsets padding;

  @override
  _SectionHeaderState createState() => _SectionHeaderState();
}

class _SectionHeaderState extends State<SectionHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Row(
        children: [
          Text(
            widget.title,
            style: Get.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (widget.onViewAllTap != null)
            TextButton(
              onPressed: widget.onViewAllTap,
              child: Text(
                "View All",
                style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.m1),
              ),
            ),
        ],
      ),
    );
  }
}
