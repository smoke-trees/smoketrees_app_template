import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:{{project_name}}/theme/colors.dart';

import '../../utils/utils.dart';
import '../buttons/main_button.dart';

class CustomDialogCard extends StatefulWidget {
  const CustomDialogCard({
    Key? key,
    required this.title,
    this.icon,
    required this.actions,
    required this.actionsTap,
    this.mainCTAOnLeft = false,
  }) : super(key: key);

  final String title;
  final IconData? icon;
  final List<String> actions;
  final List<VoidCallback> actionsTap;
  final bool mainCTAOnLeft;

  @override
  _CustomDialogCardState createState() => _CustomDialogCardState();
}

class _CustomDialogCardState extends State<CustomDialogCard> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      // backgroundColor: AppColors.chipBgColor,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: Get.textTheme.displaySmall!.copyWith(
                  color: AppColors.dark,
                  fontSize: 22,
                ),
              ),
              35.h,
              if (widget.actions.isNotEmpty)
                MainButton(
                  title: widget.actions.elementAt(0),
                  onTap: widget.actionsTap.elementAt(0),
                  color: AppColors.dark,
                  isOutlined: true,
                ),
              10.h,
              widget.actions.length > 1
                  ? MainButton(
                      title: widget.actions.elementAt(1),
                      isOutlined: false,
                      color: AppColors.dark,
                      onTap: widget.actionsTap.elementAt(1),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
