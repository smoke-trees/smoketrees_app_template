import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smoketrees_app_template/theme/colors.dart';

import '../../../utils/utils.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key, this.title, this.actions}) : super(key: key);
  final String? title;
  final List<Widget>? actions;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: AppColors.grey1,
          foregroundColor: AppColors.dark,
          elevation: 0,
          title: widget.title != null
              ? Text(
                  widget.title ?? "",
                  style: Get.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                )
              : null,
          actions: [...?widget.actions, 20.w],
        ),
      ),
    );
  }
}
