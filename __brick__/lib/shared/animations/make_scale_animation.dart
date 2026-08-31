import 'package:flutter/material.dart';

class MakeScaleAnimation extends StatefulWidget {
  const MakeScaleAnimation({
    super.key,
    required this.child,
    this.reverse = false,
    this.duration = const Duration(milliseconds: 500),
  });

  final Widget child;
  final bool reverse;
  final Duration duration;

  @override
  _MakeScaleAnimationState createState() => _MakeScaleAnimationState();
}

class _MakeScaleAnimationState extends State<MakeScaleAnimation>
    with SingleTickerProviderStateMixin {
  bool isReported = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.reverse) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _animationController.value,
          child: widget.child,
        );
      },
    );
  }
}
