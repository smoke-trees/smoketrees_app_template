import 'package:flutter/material.dart';
import 'package:smoketrees_app_template/theme/colors.dart';

class CarouselDots extends StatelessWidget {
  const CarouselDots({
    Key? key,
    required this.length,
    required this.activeIndex,
    this.expand = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 0),
    this.activeSize = const Size(50, 5),
    this.inActiveSize = const Size(5, 5),
    this.spacing = const EdgeInsets.only(right: 5),
  }) : super(key: key);
  final int length;
  final bool expand;
  final int activeIndex;
  final Size activeSize;
  final Size inActiveSize;
  final EdgeInsets padding;
  final EdgeInsets spacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          length,
          (index) => makeExpanded(
            child: AnimatedContainer(
              width: activeIndex == index
                  ? activeSize.width
                  : inActiveSize.width,
              margin: spacing,
              height: activeIndex == index
                  ? activeSize.height
                  : inActiveSize.height,
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: activeIndex == index || activeIndex > index
                    ? Colors.black
                    : AppColors.grey,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget makeExpanded({required Widget child}) {
    if (expand) {
      return Expanded(child: child);
    }
    return child;
  }
}
