import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:smoketrees_app_template/shared/fields/year_picker_widget.dart';
import 'package:smoketrees_app_template/theme/colors.dart';
import 'package:smoketrees_app_template/theme/decorations.dart';
import 'package:smoketrees_app_template/utils/console_logger.dart';

import '../../utils/utils.dart';
import '../buttons/main_button.dart';

class DateTimeField extends StatelessWidget {
  const DateTimeField({
    super.key,
    required this.hintText,
    this.initialValue,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.isMonthYearPicker = false,
    this.isYearPicker = false,
    this.isDatePicker = false,
    this.isBottomDatePicker = false,
    this.yearPickerTitle,
    this.validator,
    this.controller,
    this.borderRadius,
    this.borderColor,
    this.fillColor,
  });

  final String hintText;
  final DateTime? initialValue;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime?>? onChanged;
  final bool isMonthYearPicker;
  final bool isYearPicker;
  final bool isDatePicker;
  final bool isBottomDatePicker;
  final String? yearPickerTitle;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    String formattedDate = AppUtils().formatDateTime(
      initialValue,
      showDateTime: true,
    );
    if (isYearPicker) {
      formattedDate = initialValue?.year.toString() ?? "";
    } else if (isDatePicker || isBottomDatePicker) {
      formattedDate = AppUtils().formatDateTime(
        initialValue,
        format: "dd/MM/yyyy",
      );
    } else if (isMonthYearPicker) {
      formattedDate = AppUtils().formatDateTime(
        initialValue,
        format: "MM/yyyy",
      );
    }
    return TextFormField(
      controller: TextEditingController(text: formattedDate),
      readOnly: true,
      style: Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
      onTap: () async {
        DateTime? dateTime;
        if (isYearPicker) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: YearPickerWidget(
                  title: yearPickerTitle,
                  initialValue: initialValue,
                  firstDate: firstDate,
                  lastDate: lastDate,
                  onChanged: (value) {
                    dateTime = value;
                  },
                ),
              );
            },
          );
        } else if (isMonthYearPicker) {
          dateTime = await showMonthYearPicker(
            context: context,
            initialDate: initialValue ?? DateTime.now(),
            firstDate: firstDate ?? DateTime(1900),
            lastDate: lastDate ?? DateTime.now(),
          );
        } else if (isDatePicker) {
          dateTime = await showDatePicker(
            context: context,
            initialDate: initialValue ?? DateTime.now(),
            firstDate: firstDate ?? DateTime(1900),
            lastDate: lastDate ?? DateTime.now(),
            initialEntryMode: DatePickerEntryMode.calendarOnly,
          );
        } else if (isBottomDatePicker) {
          dateTime = await showBottomDatePicker(
            context: context,
            initialDate: initialValue ?? DateTime.now(),
            firstDate: firstDate ?? DateTime(1900),
            lastDate: lastDate ?? DateTime.now(),
          );
        } else {
          dateTime = await showDateTimePicker(
            context: context,
            firstDate: firstDate,
            lastDate: lastDate,
            initialDate: initialValue,
          );
        }
        if (!context.mounted) return;
        onChanged?.call(dateTime);
      },
      validator: validator,
      decoration: filledInputDecoration(
        fillColor: fillColor,
        hintText: hintText,
        borderRadius: borderRadius,
        borderColor: borderColor,
        // suffixIcon: const Icon(Icons.calendar_month_outlined),
      ),
    );
  }

  Future<DateTime?> showMonthYearPicker({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    return await showDatePicker(
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.black),
          dialogTheme: DialogThemeData(backgroundColor: AppColors.white),
        ),
        child: child!,
      ),
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      barrierColor: AppColors.grey2.withValues(alpha: 0.5),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
  }
}

Future<DateTime?> showBottomDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  initialDate ??= DateTime.now();
  firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
  lastDate ??= firstDate.add(const Duration(days: 365 * 200));

  DateTime selectedDateTime = initialDate;

  final result = await showDialog<DateTime>(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.4,
          maxWidth: Get.width * 0.8,
        ),
        child: Padding(
          padding: 20.p,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Date', style: Get.textTheme.bodyLarge),
              Expanded(
                flex: 6,
                child: ScrollDatePicker(
                  selectedDate: selectedDateTime,
                  maximumDate: lastDate,
                  minimumDate: firstDate,
                  scrollViewOptions: DatePickerScrollViewOptions(
                    day: ScrollViewDetailOptions(
                      selectedTextStyle: Get.textTheme.bodyLarge ?? TextStyle(),
                      textStyle: Get.textTheme.bodyLarge ?? TextStyle(),
                    ),
                    year: ScrollViewDetailOptions(
                      selectedTextStyle: Get.textTheme.bodyLarge ?? TextStyle(),
                      textStyle: Get.textTheme.bodyLarge ?? TextStyle(),
                    ),
                    month: ScrollViewDetailOptions(
                      selectedTextStyle: Get.textTheme.bodyLarge ?? TextStyle(),
                      textStyle: Get.textTheme.bodyLarge ?? TextStyle(),
                    ),
                  ),
                  onDateTimeChanged: (value) {
                    ConsoleLogger.debug(value.toIso8601String());
                    selectedDateTime = value;
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: 12.hp,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MainButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        title: 'Cancel',
                        showLoader: true,
                        loadingColor: AppColors.textDark,
                        color: AppColors.white,
                        textStyle: Get.textTheme.headlineSmall?.copyWith(
                          color: AppColors.textDark,
                          fontSize: 16,
                        ),
                        padding: 8.vp,
                      ),
                      MainButton(
                        onTap: () {
                          Navigator.pop(context, selectedDateTime);
                        },
                        title: 'Continue',
                        padding: const EdgeInsetsGeometry.symmetric(
                          vertical: 0,
                          horizontal: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
  ConsoleLogger.debug(result?.toIso8601String() ?? 'na');

  return result; // ✅ return dialog result
}

Future<DateTime?> showDateTimePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  initialDate ??= DateTime.now();
  firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
  lastDate ??= firstDate.add(const Duration(days: 365 * 200));

  final DateTime? selectedDate = await showDatePicker(
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.red,
            onSurface: Colors.white,
          ),
          datePickerTheme: const DatePickerThemeData(
            headerBackgroundColor: Colors.red,
            headerForegroundColor: Colors.white,
            backgroundColor: Colors.white,
          ),
          dialogTheme: DialogThemeData(backgroundColor: Colors.white),
        ),
        child: child!,
      );
    },
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  if (selectedDate == null) return null;

  if (!context.mounted) return selectedDate;

  final TimeOfDay? selectedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate),
  );

  return selectedTime == null
      ? initialDate
      : DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
}
