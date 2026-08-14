import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/assets.dart';

class AddButton extends StatefulWidget {
  final Future<void> Function() onTap;
  const AddButton({super.key, required this.onTap});

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() => isLoading = true);
        await widget.onTap();
        setState(() => isLoading = false);
      },
      child: Container(
        height: 26,
        width: 26,
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: !isLoading
            ? SvgPicture.asset(AppAssets.plus)
            : const CircularProgressIndicator(
                strokeCap: StrokeCap.round,
                color: Colors.black,
                strokeWidth: 4,
              ),
      ),
    );
  }
}
