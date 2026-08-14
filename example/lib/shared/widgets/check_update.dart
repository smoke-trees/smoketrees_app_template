import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smoketrees_app_template/utils/console_logger.dart';
import 'package:version/version.dart';

import '../../core/controllers/app_settings_controller.dart';
import '../../core/controllers/device_controller.dart';
import '../../core/models/app_update.dart';
import '../../utils/utils.dart';
import '../dialogs/custom_dialog.dart';

class AppUpdateChecker extends StatefulWidget {
  const AppUpdateChecker({super.key, required this.child});

  final Widget child;

  @override
  State<AppUpdateChecker> createState() => _AppUpdateCheckerState();
}

class _AppUpdateCheckerState extends State<AppUpdateChecker>
    with WidgetsBindingObserver {
  bool isDialogOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (mounted) {
    //     checkAppUpdate();
    //   }
    // });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("resumed");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          isDialogOpen = Get.isDialogOpen ?? false;
          checkAppUpdate(forceCheck: true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  Future<bool?> checkAppUpdate({bool forceCheck = false}) async {
    Map<String, String> deviceDetails = await DeviceController.to
        .getDeviceDetails();
    Version? localVersion;

    if (deviceDetails["version"] != null) {
      localVersion = Version.parse(deviceDetails["version"]!);
      ConsoleLogger.info("Local version: $localVersion");

      AppUpdate? appUpdate = AppSettingsController.to.appUpdate.value;
      if (forceCheck || appUpdate == null) {
        appUpdate = await AppSettingsController.to.getAppUpdate();
      }
      if (appUpdate != null) {
        Version? forceUpdateMinimumVersion;
        Version? softUpdateMinimumVersion;
        String? forceUpdateMinimumVersionString;
        String? softUpdateMinimumVersionString;

        if (Platform.isAndroid) {
          forceUpdateMinimumVersion =
              appUpdate.forceUpdateMinimumVersionAndroid != null
              ? Version.parse(appUpdate.forceUpdateMinimumVersionAndroid!)
              : null;
          forceUpdateMinimumVersionString =
              appUpdate.forceUpdateMinimumVersionAndroid;
          softUpdateMinimumVersionString =
              appUpdate.softUpdateMinimumVersionAndroid;
          softUpdateMinimumVersion =
              appUpdate.softUpdateMinimumVersionAndroid != null
              ? Version.parse(appUpdate.softUpdateMinimumVersionAndroid!)
              : null;
        } else if (Platform.isIOS) {
          forceUpdateMinimumVersionString =
              appUpdate.forceUpdateMinimumVersionIos;
          softUpdateMinimumVersionString =
              appUpdate.softUpdateMinimumVersionIos;
          forceUpdateMinimumVersion =
              appUpdate.forceUpdateMinimumVersionIos != null
              ? Version.parse(appUpdate.forceUpdateMinimumVersionIos!)
              : null;
          softUpdateMinimumVersion =
              appUpdate.softUpdateMinimumVersionIos != null
              ? Version.parse(appUpdate.softUpdateMinimumVersionIos!)
              : null;
        }

        int localVersionNumber = int.parse(
          deviceDetails["version"]!.replaceAll(RegExp(r'[^0-9]'), ''),
        );
        if (forceUpdateMinimumVersionString!.contains(".")) {
          if (forceUpdateMinimumVersion != null &&
              localVersion < forceUpdateMinimumVersion) {
            if (Get.isDialogOpen == true) {
              ConsoleLogger.info("Closing existing dialog");
              Get.back();
            }
            showUpdateDialog(forceUpdate: true);
            return true;
          }
        } else if (localVersionNumber <
            int.parse(forceUpdateMinimumVersionString)) {
          if (Get.isDialogOpen == true) {
            Get.back();
          }
          showUpdateDialog(forceUpdate: true);
        }

        if (softUpdateMinimumVersionString!.contains(".")) {
          if (softUpdateMinimumVersion != null &&
              localVersion < softUpdateMinimumVersion) {
            if (Get.isDialogOpen == true) {
              Get.back();
            }
            showUpdateDialog();
            return true;
          }
        } else if (localVersionNumber <
            int.parse(softUpdateMinimumVersionString)) {
          if (Get.isDialogOpen == true) {
            Get.back();
          }
          showUpdateDialog();
        }
      }
    }

    return false;
  }

  Future<bool?> showUpdateDialog({bool forceUpdate = false}) async {
    try {
      isDialogOpen = true;
      return await Get.dialog(
        CustomDialog(
          title: "App Update Available",
          mainIconColor: Colors.redAccent,
          description: !forceUpdate
              ? "Would you like to update the app to the latest version?"
              : "A new version of the app is available with important updates. Please update now to continue using the app.",
          actions: ["Update", if (!forceUpdate) "Maybe later"],
          mainCTAColor: Colors.black,
          mainCTAOnLeft: false,
          backgroundColor: Colors.white,
          actionsTap: [
            () async {
              await AppUtils().updateApp();
            },
            if (!forceUpdate)
              () {
                ConsoleLogger.info("Maybe later");

                Get.back(result: false);
              },
          ],
        ),
        barrierDismissible: false,
        name: "updateDialog2",
      );
    } finally {
      isDialogOpen = false;
    }
  }
}
