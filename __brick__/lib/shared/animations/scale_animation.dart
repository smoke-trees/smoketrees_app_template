import 'package:flutter/material.dart';

class ScaleAnimation extends StatefulWidget {
  const ScaleAnimation({super.key, required this.child, required this.delay});

  final Widget child;
  final double delay;

  @override
  State<ScaleAnimation> createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimation>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: (500 * widget.delay).round()),
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    controller.forward();
    return Transform.scale(
      scale: animation.value,
      child: Opacity(opacity: animation.value, child: widget.child),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
