// lib/utils/urls.dart

import 'package:flutter/foundation.dart';

class AppUrls {
  // Unchanged — real backend, used by backendDio for everything non-Stac
  static String backendUrl = "http://192.168.1.17:8080";

  /// Only for Stac.initialize's baseUrl. Kept separate from backendUrl so
  /// /to-do, /auth, etc. keep hitting the real backend while Stac screens
  /// come from the local dev server.
  ///
  /// Gated on the same --dart-define main.dart uses for cacheConfig, so a
  /// normal `flutter run` (without STAC_LOCAL_DEV=true) keeps hitting the
  /// real backend and only `stac watch`'s spawned run targets the dev server.
  static String get stacBaseUrl {
    /// Only redirect to the local dev server when actually launched by
    /// `stac watch` (which passes STAC_LOCAL_DEV=true). A plain `flutter
    /// run` in debug mode should keep hitting the real backend — using
    /// kDebugMode here means EVERY debug run defaults to localhost:8090,
    /// even ones not started through stac watch.

    // const isLocalDev = bool.fromEnvironment('STAC_LOCAL_DEV');
    if (!kDebugMode) return backendUrl;
    const host = String.fromEnvironment(
      'STAC_DEV_HOST',
      defaultValue: 'localhost',
    );
    const port = String.fromEnvironment('STAC_DEV_PORT', defaultValue: '8090');
    return 'http://$host:$port';
  }
}