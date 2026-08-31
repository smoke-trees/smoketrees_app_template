import 'package:get/get.dart';

/// Manages user authentication and profile information.
class UserController extends GetxController {
  final isLoggedIn = false.obs;
  final user = Rxn();
  final authToken = ''.obs;

  Future<void> login(String email, String password) async {
    try {
      // Add your login logic here
      isLoggedIn.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Login failed: $e');
    }
  }

  Future<void> logout() async {
    isLoggedIn.value = false;
    user.value = null;
    authToken.value = '';
  }
}
