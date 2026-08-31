import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:{{project_name}}/theme/decorations.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? labelText;
  final String? hintText;
  final double? cursorHeight;
  final double? cursorWidth;
  final Color? cursorColor;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Function? onTap;
  final bool? readOnly;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final InputCounterWidgetBuilder? buildCounter;
  final int? maxLength;
  final double? hintSize;
  final double? labelSize;
  final ValueChanged<String>? onChanged;
  final List<String>? autofillHints;

  const CustomTextField({
    Key? key,
    this.keyboardType,
    this.controller,
    this.labelText,
    this.hintText,
    this.cursorHeight,
    this.cursorWidth,
    this.cursorColor,
    this.suffix,
    this.suffixIcon,
    this.onTap,
    this.readOnly,
    this.maxLines,
    this.validator,
    this.autovalidateMode,
    this.textInputAction,
    this.borderRadius,
    this.borderColor,
    this.fillColor,
    this.inputFormatters,
    this.buildCounter,
    this.maxLength,
    this.hintSize,
    this.labelSize,
    this.onChanged,
    this.autofillHints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      buildCounter: buildCounter,
      inputFormatters: inputFormatters ?? [],
      textInputAction: textInputAction,
      maxLines: maxLines,
      validator: validator,
      autovalidateMode: autovalidateMode,
      readOnly: readOnly ?? false,
      onTap: onTap == null ? () {} : () => onTap!(),
      keyboardType: keyboardType,
      cursorHeight: cursorHeight,
      cursorWidth: cursorWidth ?? 2.0,
      onChanged: onChanged,
      cursorColor: cursorColor,
      textAlignVertical: TextAlignVertical.center,
      controller: controller,
      style: Get.textTheme.bodyLarge!.copyWith(fontSize: 16),
      enableSuggestions: true,
      autofillHints: autofillHints,
      decoration: filledInputDecoration(
        labelSize: labelSize ?? 16,
        hintSize: hintSize ?? 16,
        fillColor: fillColor,
        borderRadius: borderRadius,
        suffix: suffix,
        suffixIcon: suffixIcon,
        borderColor: borderColor,
        labelText: labelText,
        hintText: hintText,
        // isFilled: true
      ),
    );
  }
}
