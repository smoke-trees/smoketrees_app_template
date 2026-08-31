import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:{{project_name}}/theme/colors.dart';

class BadgeWidget extends StatefulWidget {
  const BadgeWidget({Key? key, required this.child, this.count})
    : super(key: key);
  final Widget child;
  final int? count;

  @override
  _BadgeWidgetState createState() => _BadgeWidgetState();
}

class _BadgeWidgetState extends State<BadgeWidget> {
  @override
  Widget build(BuildContext context) {
    return Badge(
      alignment: Alignment.topLeft,
      offset: const Offset(-5, -5),
      backgroundColor: AppColors.error,
      isLabelVisible: widget.count != null && widget.count! > 0,
      label: Text(
        widget.count.toString(),
        style: Get.textTheme.titleMedium!.copyWith(color: Colors.white),
      ),
      child: widget.child,
    );
  }
}
