import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:{{project_name}}/theme/colors.dart';

class AppToasts {
  static showToast({
    required String message,
    bool isError = false,
    Color backgroundColor = AppColors.iconTextColor,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: isError ? AppColors.error : backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}