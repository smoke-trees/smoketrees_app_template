import 'package:get/get.dart';

/// Manages data refresh state across the application.
class StDataRefreshController extends GetxController {
  final isRefreshing = false.obs;

  Future<void> refresh() async {
    try {
      isRefreshing.value = true;
      // Add your refresh logic here
      await Future.delayed(const Duration(seconds: 1));
    } finally {
      isRefreshing.value = false;
    }
  }
}
