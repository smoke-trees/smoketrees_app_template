import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../utils/console_logger.dart';
import '../models/device_info.dart';
import '../network/dio_controllers/entity_dio_extension.dart';
import '../network/response.dart';
import '../services/notification.dart';

class DeviceController {
  static DeviceController get to => DeviceController();

  final EntityDio _entityDio = EntityDio(path: "device-info");

  RxList<DeviceInfo> userDeviceInfos = <DeviceInfo>[].obs;

  String version = '';

  Future<Map<String, String>> getDeviceDetails() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? "";
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    return {
      "deviceId": deviceId,
      "version": version,
      "buildNumber": buildNumber,
    };
  }

  Future<DeviceInfo?> setDeviceInfo(String userId) async {
    Map<String, String> details = await getDeviceDetails();
    String? fcmToken = await NotificationService.getFCMToken();
    Map<String, dynamic> params = {
      'deviceId': details['deviceId'],
      'userId': userId,
      'os': Platform.isAndroid ? 'android' : 'ios',
      "currentUserVersion": details['version'],
      "currentUserBuildNumber": details['buildNumber'],
    };

    params.addIf(fcmToken != null, "fcmToken", fcmToken);

    print(params);
    print("fcmToken====");
    print(fcmToken);

    var response = await _entityDio.postQuery('', data: params);

    if (!response.status.error) {
      ConsoleLogger.success("[DeviceController] FCM token added successfully!");
      return DeviceInfo.fromJson(params).copyWith(id: response.result);
    } else {
      ConsoleLogger.warn("[DeviceController] User not present, not updating deviceInfo");
    }
    return null;
  }

  Future<bool> getDeviceInfoWithUserId({
    int? page,
    int? count,
    String? orderBy,
    String? order,
    String? userId,
    bool? nonPaginated,
  }) async {
    try {
      Map<String, dynamic> data = {
        'userId': userId,
        if (nonPaginated != null) 'nonPaginated': nonPaginated,
      };
      ApiResponse response = await _entityDio.readMany(
        page: page,
        count: count,
        order: order,
        orderBy: orderBy,
        params: data,
      );

      if (!response.status.error) {
        // Ensure the result is cast to a List<Map<String, dynamic>>
        List<DeviceInfo> deviceInfo = (response.result as List<dynamic>)
            .map((e) => DeviceInfo.fromJson(e as Map<String, dynamic>))
            .toList();
        userDeviceInfos.value = deviceInfo;
      }
      return false;
    } catch (e) {
      ConsoleLogger.error(e.toString());
      return true;
    }
  }

  // Future<DeviceInfo?> updateFCMToken(DeviceInfo? deviceInfo) async {
  //   try {
  //     String? fcmToken = await NotificationService.getFCMToken();
  //     log("[DeviceController] fetching fcmToken");
  //     DeviceInfo updatedDeviceInfo = deviceInfo!.copyWith(fcmToken: fcmToken);
  //     log("[DeviceController] fetched fcmToken");
  //     var response = await _entityDio.put(
  //         updatedDeviceInfo.id, updatedDeviceInfo.toJson(),
  //         queryParameters: {'userId': UserController.to.user!.id});
  //     log("[DeviceController] Api called");
  //     if (!response.status.error) {
  //       return updatedDeviceInfo;
  //     }
  //     log("[DeviceController] response received");
  //   } catch (e) {
  //     return null;
  //   }
  //   return null;
  // }

  Future<void> deleteDeviceInfo(String? id, {String? userId}) async {
    try {
      ConsoleLogger.info("[DeviceController] started");
      var response = await _entityDio.deleteQuery(
        id!,
        queryParameters: {'userId': userId},
      );

      if (!response.status.error) {
        ConsoleLogger.info("[DeviceController] deviceInfo deleted");
      } else {
        ConsoleLogger.warn("[DeviceController] deviceInfo not deleted");
      }
    } catch (e) {
      ConsoleLogger.error(e.toString());
    }
  }
}
