import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smoketrees_app_template/theme/colors.dart';

import '../../utils/assets.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    Key? key,
    this.readOnly = false,
    this.controller,
    this.onTap,
    this.onChanged,
    this.focusNode,
    this.disabled = false,
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0),
    this.validator,
    this.showSuffixIcon = false,
    this.showPrefixIcon = true,
    this.onSuffixIconPressed,
    this.onFieldSubmitted,
    this.hintText = 'Search',
  }) : super(key: key);

  final bool readOnly;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final bool disabled;
  final ValueChanged<String>? onChanged;
  final EdgeInsets margin;
  final String? Function(String?)? validator;
  final bool showSuffixIcon;
  final bool showPrefixIcon;
  final VoidCallback? onSuffixIconPressed;
  final void Function(String)? onFieldSubmitted;
  final String hintText;

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: TextFormField(
        onFieldSubmitted: widget.onFieldSubmitted,
        textAlign: TextAlign.start,
        cursorHeight: 14,
        cursorWidth: 1,
        onTap: widget.onTap,
        controller: widget.controller,
        readOnly: widget.readOnly,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        textInputAction: TextInputAction.search,
        style: Get.textTheme.bodyMedium?.copyWith(color: AppColors.dark),
        cursorColor: AppColors.textDark,
        validator: widget.validator,
        decoration: InputDecoration(
          isDense: true,
          hintText: widget.hintText,
          prefixIconConstraints: BoxConstraints.tight(const Size(40, 40)),
          prefixIcon: widget.showPrefixIcon
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(AppAssets.searchFilledSvg),
                )
              : null,
          suffixIcon: widget.showSuffixIcon
              ? InkWell(
                  onTap: widget.onSuffixIconPressed,
                  child: SvgPicture.asset(AppAssets.searchFilledSvg),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xffE2E2E2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xffE2E2E2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xffE2E2E2)),
          ),
          hintStyle: Get.textTheme.bodyMedium?.copyWith(
            color: const Color(0xff595D62),
            fontWeight: FontWeight.w400,
          ),
          fillColor: Colors.transparent,
          filled: true,
        ),
      ),
    );
  }
}
