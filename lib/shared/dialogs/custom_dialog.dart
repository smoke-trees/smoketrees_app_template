import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../buttons/main_button.dart';

import '../../theme/colors.dart';

Future<bool?> showCustomDialog({
  required BuildContext context,
  required String title,
  String description = "",
  required List<String> actions,
  required List<VoidCallback> actionsTap,
  bool mainCTAOnLeft = true,
  IconData? icon,
  bool barrierDismissible = true,
  Color backgroundColor = AppColors.white,
  Color mainCTAColor = Colors.black,
  Color mainIconColor = Colors.redAccent,
}) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: CustomDialog(
        title: title,
        description: description,
        icon: icon,
        actions: actions,
        actionsTap: actionsTap,
        mainCTAOnLeft: mainCTAOnLeft,
        mainCTAColor: mainCTAColor,
        backgroundColor: backgroundColor,
        mainIconColor: mainIconColor,
      ),
    ),
  );
}

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    required this.title,
    required this.description,
    required this.actions,
    required this.actionsTap,
    this.mainCTAOnLeft = true,
    this.icon,
    this.backgroundColor,
    this.mainCTAColor,
    required this.mainIconColor,
    Key? key,
  }) : super(key: key);

  final String title;
  final String description;
  final IconData? icon;
  final List<String> actions;
  final List<VoidCallback> actionsTap;
  final bool mainCTAOnLeft;
  final Color? backgroundColor;
  final Color? mainCTAColor;
  final Color mainIconColor;

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  List<Widget> bottomButtons() {
    return [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: MainButton(
            title: widget.actions.elementAt(0),
            onTap: widget.actionsTap.elementAt(0),
            color: widget.mainCTAColor!,
          ),
        ),
      ),
      const SizedBox(width: 15),
      widget.actions.length > 1
          ? Expanded(
              child: MainButton(
                title: widget.actions.elementAt(1),
                isOutlined: true,
                onTap: widget.actionsTap.elementAt(1),
                color: widget.mainCTAColor!,
              ),
            )
          : const SizedBox.shrink(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      backgroundColor: widget.backgroundColor,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Icon(
                widget.icon ?? Icons.info_outline,
                color:
                    widget.mainIconColor ??
                    Colors.redAccent.withValues(alpha: 0.8),
                size: 60,
              ),
              const SizedBox(height: 12),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: Get.textTheme.bodyLarge!.copyWith(
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              if (widget.description.isNotEmpty)
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.bodyMedium!.copyWith(
                    color: Colors.black,
                  ),
                ),
              const SizedBox(height: 25),
              if (widget.actions.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widget.mainCTAOnLeft
                      ? bottomButtons()
                      : bottomButtons().reversed.toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
