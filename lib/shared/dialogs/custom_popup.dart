import 'package:flutter/material.dart';

class CustomPopup extends StatefulWidget {
  final Widget child;
  final Duration? duration;

  const CustomPopup({super.key, required this.child, this.duration});

  @override
  State<CustomPopup> createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _showPopup();
  }

  void _showPopup() async {
    if (mounted) {
      await _controller.forward();
      await Future.delayed(widget.duration ?? const Duration(seconds: 2));
      if (mounted) {
        await _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    if (_controller.isAnimating) {
      _controller.stop();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: widget.child,
      ),
    );
  }
}

showCustomPopup(BuildContext context, Widget child) {
  OverlayEntry overlayEntry = OverlayEntry(
    maintainState: false,
    builder: (context) => Stack(
      children: [
        CustomPopup(child: child),
      ],
    ),
  );

  Overlay.of(context).insert(overlayEntry);
}
