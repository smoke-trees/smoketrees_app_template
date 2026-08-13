import 'package:flutter/material.dart';
import 'package:get/get.dart';

class YearPickerWidget extends StatefulWidget {
  final DateTime? initialValue;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onChanged;
  final String? title;

  const YearPickerWidget({
    Key? key,
    this.initialValue,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.title,
  }) : super(key: key);

  @override
  _YearPickerWidgetState createState() => _YearPickerWidgetState();
}

class _YearPickerWidgetState extends State<YearPickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        Text(
          widget.title ?? "Select Year",
          style: Get.textTheme.displaySmall,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 250,
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: Colors.black),
              ),
            ),
            child: YearPicker(
              firstDate: widget.firstDate ?? DateTime(1900),
              lastDate: widget.lastDate ?? DateTime.now(),
              selectedDate:
                  DateTime(widget.initialValue?.year ?? DateTime.now().year),
              onChanged: (DateTime dateTime) {
                widget.onChanged?.call(dateTime);
                Get.back();
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
