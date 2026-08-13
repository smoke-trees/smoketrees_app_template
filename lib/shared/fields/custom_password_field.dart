import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/colors.dart';
import '../../theme/decorations.dart';

class CustomPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final RxBool isPasswordVisible;
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;

  const CustomPasswordField({
    Key? key,
    required this.controller,
    required this.isPasswordVisible,
    required this.labelText,
    required this.hintText,
    this.validator,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextFormField(
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: textInputAction,
        validator: validator,
        obscureText: !isPasswordVisible.value,
        cursorHeight: 16,
        cursorWidth: 1,
        cursorColor: AppColors.grey2,
        controller: controller,
        style: Get.textTheme.bodyLarge!.copyWith(fontSize: 16),
        decoration: filledInputDecoration(
          suffixIcon: GestureDetector(
            onTap: () {
              isPasswordVisible.value = !isPasswordVisible.value;
            },
            child: Icon(
              isPasswordVisible.value
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
            ),
          ),
          // labelText: labelText,
          hintText: hintText,
          // isFilled: false,
        ),
      ),
    );
  }
}
