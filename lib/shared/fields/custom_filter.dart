import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smoketrees_app_template/theme/colors.dart';

import '../../../utils/utils.dart';

class CourseDuration {
  final String title;
  final int duration;

  CourseDuration(this.title, this.duration);
}

class CustomFilter extends StatefulWidget {
  const CustomFilter({
    super.key,
    this.value,
    this.hint,
    required this.onChanged,
  });

  final String? value;
  final String? hint;
  final ValueChanged<Map<String, dynamic>> onChanged;

  @override
  State<CustomFilter> createState() => _CustomFilterState();
}

class _CustomFilterState extends State<CustomFilter> {
  DateTime? _fromDate;
  DateTime? _toDate;

  Future<DateTime?> _selectDate({
    String text = "Select Date",
    DateTime? initialDate,
    DateTime? firstDate,
  }) async {
    DateTime? pickedDate = initialDate ?? DateTime.now();
    await showModalBottomSheet(
      context: context,
      enableDrag: false,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            10.h,
            Text(text, style: Get.textTheme.displaySmall),
            10.h,
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: pickedDate,
                minimumDate: firstDate ?? DateTime(2000),
                maximumDate: DateTime.now(),
                onDateTimeChanged: (DateTime dateTime) {
                  pickedDate = dateTime;
                },
              ),
            ),
            CupertinoButton(
              child: const Text('Done'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );

    return pickedDate;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        value: widget.value,
        hint: Text(widget.hint ?? ""),
        style: Get.textTheme.titleMedium?.copyWith(color: AppColors.dark),
        iconStyleData: const IconStyleData(iconEnabledColor: AppColors.m2),
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.m2),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
        items:
            <String>[
              // 'Yesterday',
              'Last Week',
              'Last Month',
              'Previous Year',
              'Custom Range',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
        onChanged: (String? newValue) async {
          if (newValue == 'Custom Range') {
            _fromDate = await _selectDate(text: "From Date");
            if (_fromDate != null) {
              _toDate = await _selectDate(
                text: "To Date",
                initialDate: _fromDate,
                // firstDate: _fromDate,
              );
            }
          } else if (newValue == 'Yesterday') {
            _fromDate = DateTime.now().subtract(const Duration(days: 1));
            _toDate = DateTime.now().subtract(const Duration(days: 1));
          } else if (newValue == 'Last Week') {
            _fromDate = DateTime.now().subtract(const Duration(days: 7));
            _toDate = DateTime.now().subtract(const Duration(days: 1));
          } else if (newValue == 'Last Month') {
            _fromDate = DateTime.now().subtract(const Duration(days: 30));
            _toDate = DateTime.now().subtract(const Duration(days: 1));
          } else if (newValue == 'Previous Year') {
            _fromDate = DateTime.now().subtract(const Duration(days: 365));
            _toDate = DateTime.now().subtract(const Duration(days: 1));
          }

          Map<String, dynamic> data = {
            "startDate": _fromDate,
            "endDate": _toDate,
            "value": newValue,
            "isCustomRange": newValue == 'Custom Range',
          };

          widget.onChanged(data);
        },
      ),
    );
  }
}
