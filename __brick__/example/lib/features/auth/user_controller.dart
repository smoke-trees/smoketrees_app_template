import 'package:get/get.dart';
import 'package:smoketrees_app_template/smoketrees_app_template.dart';

class UserController extends GetxController {
  final user = Rxn<UserModel>();
  final isLoggedIn = false.obs;

  Future<void> signIn(String email, String password) async {
    try {
      final dio = Get.find<GlobalService>().backendDio;
      final response = await dio.post('/auth/sign-in', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final userData = response.data['result'];
        user.value = UserModel.fromJson(userData);
        isLoggedIn.value = true;

        await HiveService.set('user_token', response.data['token']);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      final dio = Get.find<GlobalService>().backendDio;
      final response = await dio.post('/auth/sign-up', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        Get.back();
        Get.snackbar('Success', 'Account created successfully');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> signOut() async {
    user.value = null;
    isLoggedIn.value = false;
    await HiveService.delete('user_token');
  }

  Future<void> loadUser() async {
    final token = await HiveService.get('user_token');
    if (token != null) {
      isLoggedIn.value = true;
    }
  }
}
