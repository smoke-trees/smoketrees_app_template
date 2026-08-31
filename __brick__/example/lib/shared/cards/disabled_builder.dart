import 'package:flutter/material.dart';
import 'package:{{project_name}}/theme/colors.dart';

class DisabledBuilder extends StatelessWidget {
  const DisabledBuilder({
    super.key,
    required this.disabled,
    required this.child,
  });

  final bool disabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disabled,
      child: !disabled
          ? child
          : ColorFiltered(
              colorFilter: ColorFilter.mode(
                AppColors.dark.withValues(alpha: 0.2),
                BlendMode.multiply,
              ),
              child: child,
            ),
    );
  }
}
