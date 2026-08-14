// import 'package:country/country.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:smoketrees_app_template/theme/colors.dart';
// import '../../../utils/themes/decorations.dart';

// class CustomDropdownField<T> extends StatefulWidget {
//   const CustomDropdownField({
//     super.key,
//     required this.items,
//     this.value,
//     this.onChanged,
//     required this.hintText,
//     this.validationMessage,
//     this.showErrorMessage = false,
//   });

//   final List<T> items;
//   final T? value;
//   final ValueChanged<T?>? onChanged;
//   final String hintText;
//   final String? validationMessage;
//   final bool showErrorMessage;

//   @override
//   _CustomDropdownFieldState createState() => _CustomDropdownFieldState<T>();
// }

// class _CustomDropdownFieldState<T> extends State<CustomDropdownField<T>> {
//   FocusNode focusNode = FocusNode();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Stack(
//           alignment: AlignmentDirectional.topStart,
//           clipBehavior: Clip.none,
//           children: [
//             Container(
//               alignment: AlignmentDirectional.center,
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
//               decoration: BoxDecoration(
//                 color: AppColors.grey1,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                     color: widget.showErrorMessage
//                         ? AppColors.error
//                         : AppColors.iconTextColor,
//                     width: 0.5),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton2<T>(
//                   isExpanded: true,
//                   value: widget.value,
//                   hint: Text(
//                     widget.hintText,
//                     style: AppDecorations.hintTextStyle,
//                   ),
//                   onChanged: (value) {
//                     if (widget.onChanged != null) {
//                       setState(() {
//                         widget.onChanged!(value);
//                       });
//                     }
//                   },
//                   items: widget.items.map((item) {
//                     return DropdownMenuItem(
//                       value: item,
//                       enabled: true,
//                       child: (item is Country)
//                           ? Row(
//                               children: [
//                                 Text(
//                                   "${item.flagEmoji} ",
//                                   style: Get.textTheme.bodyLarge?.copyWith(
//                                     color: Colors.black,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Text(
//                                     item.isoShortName,
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             )
//                           : Text(
//                               item is String
//                                   ? item
//                                   : item is CareerStatus
//                                       ? item.string
//                                       : item.toString(),
//                               style: const TextStyle(
//                                 fontSize: 14,
//                               ),
//                             ),
//                     );
//                   }).toList(),
//                   iconStyleData: const IconStyleData(
//                     icon: Icon(
//                       Icons.arrow_drop_down,
//                       color: Colors.black45,
//                     ),
//                     iconSize: 24,
//                   ),
//                   dropdownStyleData: DropdownStyleData(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     width: Get.width - 40,
//                     maxHeight: 300,
//                     offset: const Offset(-20, -10),
//                     direction: DropdownDirection.textDirection,
//                     // scrollPadding:
//                     //     EdgeInsets.only(bottom: Get.mediaQuery.viewInsets.bottom),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                   menuItemStyleData: const MenuItemStyleData(
//                     padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         if (widget.validationMessage != null && widget.showErrorMessage)
//           Padding(
//             padding: const EdgeInsets.only(top: 5.0, left: 20),
//             child: Text(
//               widget.validationMessage!,
//               style: Get.textTheme.bodyLarge?.copyWith(
//                 color: AppColors.error,
//                 fontSize: 12,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
