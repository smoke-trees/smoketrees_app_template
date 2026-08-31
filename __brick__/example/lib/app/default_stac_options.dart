import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smoketrees_app_template/smoketrees_app_template.dart';

import '../counter/counter_screen_controller.dart';
import '../counter/stac/counter_screen_parser.dart';

class DefaultStacOptions {
  static StacOptions get stacOptions => StacOptions(
    parsers: [
      const CounterScreenParser(),
    ],
    serializers: [],
    actions: [],
    theme: AppTheme.light,
  );
}

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: AppColors.primary,
    brightness: Brightness.light,
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: AppColors.primary,
    brightness: Brightness.dark,
  );
}
