import 'package:get/get.dart' hide FormData, MultipartFile;

import '../../utils/console_logger.dart';
import '../models/app_update.dart';
import '../models/application_settings.dart';
import '../network/dio_controllers/entity_dio_extension.dart';
import '../network/response.dart';

class AppSettingsController extends GetxController {
  static AppSettingsController get to => Get.find();

  final EntityDio _entityDio = EntityDio(path: "application-settings");

  RxList<AppSettings> appSettingsList = <AppSettings>[].obs;

  Rxn<AppUpdate> appUpdate = Rxn<AppUpdate>();

  Future<List<AppSettings>?> getAppSettings() async {
    ApiResponse<List<dynamic>> response = await _entityDio.readMany(
      count: 100,
      params: {
        "orderBy": "updatedAt",
        "order": "DESC",
        "isPublic": true,
        "nonPaginated": true,
        // "userId": UserController.to.user?.id,
        // if (isActive != null) "isActive": isActive,
      },
    );
    if (!response.status.error) {
      ConsoleLogger.info("[AppSettingsController] getAppleSettings(Success)");
      List<AppSettings>? appSettings = response.result!
          .map((e) => AppSettings.fromMap(e))
          .toList();
      appSettingsList.value = appSettings;
      // update();
      return appSettings;
    } else {
      // user=null;
      // update();
      ConsoleLogger.warn(
        "[AppSettingsController] getAppleSettings(Failed): ${response.message}",
      );
      return null;
    }
  }

  AppSettings? getPromoBannerSettings() {
    if (appSettingsList.isEmpty) return null;
    return appSettingsList
        .where((e) => e.name == 'promoBannerImage')
        .firstOrNull;
  }

  Future<AppSettings?> getAppSettingsByName(String name) async {
    if (appSettingsList.isNotEmpty) {
      AppSettings res = appSettingsList.firstWhere(
        (element) => element.name == name,
        orElse: () => AppSettings(name: null),
      );
      return res.name == null ? null : res;
    }
    return null;
  }

  Future<AppSettings?> getAppSettingsById(String id) async {
    ApiResponse<Map<String, dynamic>> response = await _entityDio.read(id);
    if (!response.status.error) {
      ConsoleLogger.info("[AppSettingsController] getAppSettingsById(Success)");
      AppSettings? appSettings = AppSettings.fromMap(response.result!);

      return appSettings;
    } else {
      // user=null;
      // update();
      ConsoleLogger.warn(
        "[AppSettingsController] getAppSettingsById(Failed): ${response.message}",
      );
      return null;
    }
  }

  Future<AppUpdate?> getAppUpdate() async {
    // return AppUpdate(
    //   forceUpdateMinimumVersionAndroid: "2.0.1",
    //   forceUpdateMinimumVersionIos: "2.0.5",
    //   softUpdateMinimumVersionAndroid: "2.0.1",
    //   softUpdateMinimumVersionIos: "2.0.6",
    // );
    try {
      ApiResponse<List<dynamic>> response = await _entityDio.readMany(
        count: 100,
        params: {
          "orderBy": "updatedAt",
          "order": "DESC",
          "isPublic": true,
          "nonPaginated": true,
          // "userId": UserController.to.user?.id,
          // if (isActive != null) "isActive": isActive,
        },
      );
      if (!response.status.error) {
        ConsoleLogger.info("[AppSettingsController] getAppUpdate(Success)");
        List<AppSettings>? appSettings = response.result!
            .map((e) => AppSettings.fromMap(e))
            .toList();
        appSettingsList.value = appSettings;

        if (appSettings.isNotEmpty) {
          appUpdate.value = AppUpdate();
          for (var element in appSettings) {
            if (element.isPublic ?? false) {
              if (element.name == "forceUpdateMinimumVersionAndroid") {
                appUpdate.value?.forceUpdateMinimumVersionAndroid =
                    element.value;
              }
              if (element.name == "softUpdateMinimumVersionAndroid") {
                appUpdate.value?.softUpdateMinimumVersionAndroid =
                    element.value;
              }

              if (element.name == "forceUpdateMinimumVersionIos") {
                appUpdate.value?.forceUpdateMinimumVersionIos = element.value;
              }

              if (element.name == "softUpdateMinimumVersionIos") {
                appUpdate.value?.softUpdateMinimumVersionIos = element.value;
              }
            }
          }
          print("appUpdate ${appUpdate.toJson()} ");
          return appUpdate.value;
        }
      } else {
        ConsoleLogger.warn(
          "[AppSettingsController] getAppUpdate(Failed): ${response.message}",
        );
        return null;
      }
    } catch (e) {}
    return null;
  }
}
