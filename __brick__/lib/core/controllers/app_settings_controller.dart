import 'package:get/get.dart';

/// Manages application settings like theme, language, etc.
class AppSettingsController extends GetxController {
  final isDarkMode = false.obs;
  final language = 'en'.obs;

  void toggleDarkMode() {
    isDarkMode.toggle();
  }

  void setLanguage(String lang) {
    language.value = lang;
  }
}
