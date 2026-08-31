import 'package:flutter/material.dart';
import 'package:{{project_name}}/theme/colors.dart';

import '../../utils/utils.dart';

class CustomExpansionTile extends StatelessWidget {
  const CustomExpansionTile({
    Key? key,
    required this.body,
    required this.header,
    this.isExpanded = false,
    this.onExpansionChanged,
    this.itemGap = 0,
    this.showIcon = false,
  }) : super(key: key);
  final Widget body;
  final Widget header;
  final bool isExpanded;
  final double itemGap;
  final bool showIcon;

  final Function(dynamic value)? onExpansionChanged;

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      contentPadding: 0.p,
      minLeadingWidth: 0,
      style: ListTileStyle.list,
      child: ExpansionTile(
        tilePadding: 0.p,
        expandedAlignment: Alignment.centerLeft,
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.grey1, width: 3),
        ),
        collapsedBackgroundColor: AppColors.white,
        trailing: showIcon
            ? const Icon(Icons.keyboard_arrow_down_sharp, color: AppColors.grey)
            : const SizedBox.shrink(),
        leading: const SizedBox.shrink(),
        childrenPadding: EdgeInsets.zero,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        onExpansionChanged: onExpansionChanged,
        initiallyExpanded: isExpanded,
        title: header,
        textColor: AppColors.textDark,
        collapsedTextColor: AppColors.textDark,
        children: [body],
      ),
    );
  }
}
