import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../theme/colors.dart';

import '../../../../utils/utils.dart';
import 'st_custom_bottom_bar.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({
    super.key,
    required this.model,
    required this.currentIndex,
    required this.onTap,
  });
  final StCustomBottomBar model;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: const Color(0xffF5F5F5),
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(widget.model.labels.length, (index) {
          final isSelected = index == widget.currentIndex;
          final isSpecial =
              widget.model.specialIndex != null &&
              index == widget.model.specialIndex;

          final icon = AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: 8.p,
            decoration: ShapeDecoration(
              shape: const CircleBorder(),
              color: isSelected ? Colors.black : AppColors.transparent,
            ),
            child: SvgPicture.asset(
              isSelected
                  ? widget.model.svgIcons[index]
                  : widget.model.svgFilledIcons[index],
              semanticsLabel: widget.model.labels[index],
            ),
          );

          return GestureDetector(
            onTap: () => widget.onTap(index),
            child: isSpecial
                ? Stack(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    children: [icon],
                  )
                : icon,
          );
        }),
      ),
    );
  }
}
