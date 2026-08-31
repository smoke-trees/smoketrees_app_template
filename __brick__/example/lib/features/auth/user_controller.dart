import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:{{project_name}}/utils/console_logger.dart';

import '../../core/models/user.dart';
import '../../core/network/dio_controllers/entity_dio_extension.dart';
import '../../core/network/response.dart';
import '../../utils/utils.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  final EntityDio _entityDio = EntityDio(path: 'user');

  RxMap<String, User> userMap = RxMap<String, User>();
  final Rxn<User?> _user = Rxn<User?>();

  User? get user => _user.value;
  Box<User?> userBox = Hive.box<User?>('userBox');

  set user(User? value) => _user.value = value;

  @override
  void onInit() async {
    ConsoleLogger.info('usercontroller oninit');
    super.onInit();
    User? user = await fetchUserFromHive();
    if (user != null) {
      await fetchUserById(user.id!);
    }
  }

  Future<List<User>> fetchUsers({int? page, int? count}) async {
    try {
      var response = await _entityDio.readMany(page: page, count: count);
      if (response.status.error || (response.result?.isEmpty ?? true)) {
        return [];
      }

      List<User> userList = response.result!
          .map((e) => User.fromJson(e))
          .toList();
      userMap.addAll({for (var user in userList) user.id!: user});
      return userList;
    } catch (e) {
      return [];
    }
  }

  Future<User?> fetchUserById(String id) async {
    try {
      var response = await _entityDio.read(id);
      ConsoleLogger.info('[UserController] fetchUserById: $response');
      if (response.status.error || (response.result?.isEmpty ?? true)) {
        ConsoleLogger.info(
          '[UserController] fetchUserById: response.result is empty',
        );
        return null;
      }
      ConsoleLogger.info(
        '[UserController] fetchUserById: response.result is not empty',
      );

      User user = User.fromJson(response.result!);
      userMap.addAll({user.id!: user});
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<User?>? fetchUserFromHive() async {
    User? hiveUser = userBox.get("user");
    if (hiveUser != null) {
      ConsoleLogger.info("[UserController] Fetched user from Hive");

      user = hiveUser;
      ConsoleLogger.debug(hiveUser.accessToken ?? "");
      return user;
    } else {
      user = null;
      update();
      ConsoleLogger.info("[UserController] No saved user in Hive");
      return null;
    }
  }

  Future<ApiResponse?> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      var response = await _entityDio.postQuery(
        'sign-up',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
        },
      );
      if (!response.status.error) {
        user = await AppUtils().extractUserDataFromJWT(
          response.result!["tokens"]["accessToken"],
        );
        if (user != null) {
          user?.accessToken = response.result!["tokens"]["accessToken"];
          user?.refreshToken = response.result!["tokens"]["refreshToken"];

          saveToHive(user);
        }
      }
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> saveToHive(User? user) async {
    if (user != null) {
      ConsoleLogger.info("[UserController] Changes in user saved to Hive");
      userBox.put("user", user);
      this.user = userBox.get("user");
      update();
    }
  }

  Future<ApiResponse?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      var response = await _entityDio.postQuery(
        'sign-in',
        data: {'email': email, 'password': password},
      );
      if (!response.status.error) {
        ConsoleLogger.success(
          "[UserController] Sign in successful ${response.result}",
        );
        user = await AppUtils().extractUserDataFromJWT(
          response.result!["accessToken"],
        );
        if (user != null) {
          user?.accessToken = response.result["accessToken"];
          user?.refreshToken = response.result["refreshToken"];

          saveToHive(user);
        }
      }
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<ApiResponse?> invalidateToken() async {
    try {
      var response = await _entityDio.postQuery(
        'invalidate-token',
        data: {'refreshToken': user?.refreshToken},
      );
      if (!response.status.error) {
        user = null;
        update();
      }
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool?> logout() async {
    try {
      var response = await invalidateToken();
      if (response?.status.error ?? true) {
        ConsoleLogger.warn(
          "[UserController] Logout failed: ${response?.message}",
        );
        return false;
      }
      await clear();
      return true;
    } catch (e) {
      ConsoleLogger.error("[UserController] Logout failed: $e");
      return false;
    }
  }

  Future<void> clear() async {
    _user.value = null;
    await userBox.clear();
    update();
  }
}
