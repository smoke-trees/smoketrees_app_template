import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:stac/stac.dart';
import 'package:version/version.dart';

import '../../core/controllers/app_settings_controller.dart';
import '../../core/controllers/device_controller.dart';
import '../../core/models/app_update.dart';
import '../../core/services/app_links.dart';
import '../../core/services/global_service.dart';
import '../../shared/dialogs/custom_dialog.dart';
import '../../shared/pages/no_internet_page/no_internet_page_page.dart';
import '../../utils/console_logger.dart';
import '../../utils/utils.dart';
import '../auth/user_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.logoAsset});
  static String routeName = "splash_page";

  final String logoAsset;

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isForceUpdateAvailable = false;
  bool isSoftUpdateAvailable = false;

  @override
  initState() {
    super.initState();
    GlobalService.to.resetErrorFlags();
    AppLinksService().init();
    print('splash screen open');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ConnectivityResult connectivityResult = (await Connectivity()
          .checkConnectivity())[0];
      if (connectivityResult == ConnectivityResult.none) {
        Get.offAllNamed(NoInternetPage.routeName);
      } else {
        await continueToNextPage();
      }
    });
  }

  Future<void> continueToNextPage() async {
    final user = UserController.to.user;

    Future.delayed(Duration(seconds: 5)).then((e) async {
      if (user == null) {
        await Stac.onCallFromJson(
          StacNavigator.pushReplacementStac('sign_in').toJson(),
          context,
        );
      } else {
        return await Stac.onCallFromJson(
          StacNavigator.pushReplacementStac('bottom_navigation').toJson(),
          context,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              widget.logoAsset,
              repeat: false,
              width: 250,
              height: 250,
              animate: true,
            ),

            // Image.asset(
            //   AppAssets.appLogo,
            //   width: 250,
            //   height: 250,
            // ),
          ],
        ),
      ),
    );
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
    } finally {}
  }
}
