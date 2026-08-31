import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:stac/stac.dart';

import '../features/splash/splash_page.dart';

class AppPages {
  static final List<GetPage> pages = [];
  static final Map<String, Widget Function(BuildContext)> stacPages = {
    SplashPage.routeName: (p0) => Stac(routeName: SplashPage.routeName),
    'bottom_navigation': (p0) => Stac(routeName: 'bottom_navigation'),
    'sign_in': (p0) => Stac(routeName: 'sign_in'),
    'sign_up': (p0) => Stac(routeName: 'sign_up'),
    'wildcard_page': (p0) => Stac(routeName: 'wildcard_page'),
    'profile_test_page': (p0) => Stac(routeName: 'profile_test_page'),
  };
}
