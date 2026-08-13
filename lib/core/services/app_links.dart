import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'global_service.dart';
import '../../shared/snackbars/toasts.dart';

class AppLinksService extends GetxService {
  static AppLinksService get to => Get.find();
  final _appLinks = AppLinks();
  StreamSubscription? _linkSubscription;

  Future<AppLinksService> init() async {
    // try {
    //   final appLink = await _appLinks.getInitialLink();
    //   if (appLink != null) {
    //     _handleAppLink(appLink);
    //   }
    // } on PlatformException {
    //   AppToasts.showToast(message: 'Error in opening initial link');
    // }
    ever(GlobalService.to.initializeDone, (ready) async {
      // await Future.delayed(
      //   Duration(seconds: 3),
      // );
      print('initializeDone');
      if (ready && GlobalService.to.pendingAppLinkRedirect != null) {
        handleAppLink(GlobalService.to.pendingAppLinkRedirect!);
        GlobalService.to.pendingAppLinkRedirect = null;
      }
    });
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        print('not initializeDone');
        if (GlobalService.to.initializeDone.value) {
          handleAppLink(uri);
        } else {
          GlobalService.to.pendingAppLinkRedirect = uri;
        }
      },
      onError: (error) {
        print('App link error: $error');
        AppToasts.showToast(message: 'Error processing link');
      },
    );

    return this;
  }

  void handleAppLink(Uri uri, {bool fromBlog = false}) async {
    print('Handling app link: $uri');

    final path = uri.path;
    final params = uri.pathSegments;
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }
}
