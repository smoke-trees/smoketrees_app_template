import 'package:get/get.dart';
import 'package:smoketrees_app_template/smoketrees_app_template.dart';

import '../features/splash/splash_page.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
      transition: Transition.fade,
    ),
  ];
}

abstract class Routes {
  static const splash = '/splash';
}
