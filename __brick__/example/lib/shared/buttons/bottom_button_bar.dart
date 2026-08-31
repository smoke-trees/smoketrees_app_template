import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:{{project_name}}/theme/colors.dart';

class BottomButtonBar extends StatefulWidget {
  const BottomButtonBar({
    Key? key,
    this.leftText,
    required this.rightText,
    this.onLeftTap,
    this.onRightTap,
    this.isRightDisabled = false,
  }) : super(key: key);

  final String? leftText;
  final String? rightText;
  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap;
  final bool isRightDisabled;

  @override
  _BottomButtonBarState createState() => _BottomButtonBarState();
}

class _BottomButtonBarState extends State<BottomButtonBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: AppColors.m1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.leftText != null) ...[
            Expanded(
              child: InkWell(
                onTap: widget.onLeftTap,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: AppColors.white),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    widget.leftText!,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
            if (widget.rightText != null) const SizedBox(width: 16),
          ],
          if (widget.rightText != null)
            Expanded(
              child: InkWell(
                onTap: widget.isRightDisabled ? null : widget.onRightTap,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    widget.rightText!,
                    style: Get.textTheme.bodyMedium?.copyWith(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
