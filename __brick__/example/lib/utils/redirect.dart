class AppRedirect {
  static void redirectTo(
    String type, {
    Map<String, dynamic>? arguments,
    Function()? fallback,
    bool fromInit = false,
  }) async {
    fallback = fallback ?? _defaultFallback;
  }

  static _defaultFallback() {}
}
