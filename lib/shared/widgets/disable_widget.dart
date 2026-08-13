import 'package:flutter/material.dart';

class DisableWidget extends StatelessWidget {
  const DisableWidget({
    Key? key,
    required this.child,
    this.onTap,
    this.messageShow,
    required this.disabled,
  }) : super(key: key);
  final bool disabled;
  final Widget child;
  final Function()? onTap;
  final String? messageShow;
  @override
  Widget build(BuildContext context) {
    if (!disabled) {
      return child;
    } else {
      return InkWell(
        onTap: onTap,
        child: IgnorePointer(
          ignoring: true,
          child: child,
        ),
      );
    }
  }
}
