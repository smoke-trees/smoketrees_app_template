import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'notification.dart';

class GlobalService extends GetxService {
  static GlobalService get to => Get.find();

  RxBool initializeDone = false.obs;

  RxBool hasShownErrorPage = false.obs;
  bool isNavigatingToError = false;

  RedirectingMessage? pendingNotificationPayload;

  TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;

  Uri? pendingAppLinkRedirect;
  void resetErrorFlags() {
    hasShownErrorPage.value = false;
    isNavigatingToError = false;
  }
}