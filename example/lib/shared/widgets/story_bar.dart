import 'package:flutter/material.dart';
import 'package:smoketrees_app_template/theme/colors.dart';

import '../../utils/utils.dart';

class StoryBar extends StatefulWidget {
  const StoryBar({
    Key? key,
    required this.length,
    required this.activeIndex,
    this.expand = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 0),
    this.activeSize = const Size(50, 5),
    this.inActiveSize = const Size(5, 5),
    required this.duration,
    required this.controller,
  }) : super(key: key);
  final int length;
  final bool expand;
  final int activeIndex;
  final Size activeSize;
  final Size inActiveSize;
  final EdgeInsets padding;
  final Duration duration;
  final AnimationController controller;

  @override
  State<StoryBar> createState() => _StoryBarState();
}

class _StoryBarState extends State<StoryBar> {
  @override
  void initState() {
    super.initState();

    // Uncomment the next line if you want the animation to start immediately
    // controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 0.p,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.length,
          (index) => makeExpanded(
            child: Stack(
              children: [
                Container(
                  width: widget.inActiveSize.width,
                  margin: 10.rp,
                  height: widget.inActiveSize.height,
                  decoration: BoxDecoration(
                    color: AppColors.textWhite.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                AnimatedBuilder(
                  animation: widget.controller,
                  builder: (context, child) {
                    return Container(
                      width: widget.activeIndex == index
                          ? widget.activeSize.width * widget.controller.value
                          : widget.inActiveSize.width,
                      height: 5,
                      decoration: BoxDecoration(
                        color: widget.activeIndex >= index
                            ? AppColors.textWhite
                            : AppColors.textWhite.withValues(alpha: 0.0),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeExpanded({required Widget child}) {
    if (widget.expand) {
      return Expanded(child: child);
    }
    return child;
  }
}
