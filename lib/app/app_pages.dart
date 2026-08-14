import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage> pages = [];

  /// Maps Stac route names to their screen widgets.
  ///
  /// Add screens here as you build them, for example (import
  /// `package:stac/stac.dart` for `Stac`):
  ///   'splash_page': (p0) => Stac(routeName: 'splash_page'),
  static final Map<String, Widget Function(BuildContext)> stacPages = {};
}