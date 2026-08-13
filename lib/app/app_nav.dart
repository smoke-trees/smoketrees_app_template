import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';

/// Ergonomic wrapper over [StacNavigator] for imperative (non-JSON) call
/// sites â€” e.g. a Timer callback, an auth check, anywhere you're navigating
/// from plain Dart rather than a widget's `onPressed` JSON.
///
/// [StacNavigator]'s static methods just build a `StacNavigateAction` model
/// â€” they don't navigate on their own. The actual dispatch is:
///   `Stac.onCallFromJson(StacNavigator.pushStac('x').toJson(), context)`
/// which feeds the action through the exact same pipeline the built-in
/// `navigate` action parser uses when triggered from JSON. Every method
/// below just does that one line for you, so behavior is identical whether
/// a navigation happens from JSON or from imperative code â€” one dispatch
/// path, no duplicated logic.
///
/// Usage (was 3 lines, now 1):
/// ```dart
/// await AppNav.pushStac(context, 'profile_test_page');
/// ```
class AppNav {
  const AppNav._();

  static Future<void> _dispatch(
    BuildContext context,
    StacNavigateAction action,
  ) async {
    await Stac.onCallFromJson(action.toJson(), context);
  }

  // --- pop -------------------------------------------------------------

  static Future<void> pop(
    BuildContext context, {
    Map<String, dynamic>? result,
  }) => _dispatch(context, StacNavigator.pop(result: result));

  static Future<void> popAll(BuildContext context) =>
      _dispatch(context, StacNavigator.popAll());

  // --- Stac screen -------------------------------------------------------

  static Future<void> pushStac(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? arguments,
  }) => _dispatch(
    context,
    StacNavigator.pushStac(routeName, arguments: arguments),
  );

  static Future<void> pushReplacementStac(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? result,
  }) => _dispatch(
    context,
    StacNavigator.pushReplacementStac(routeName, result: result),
  );

  static Future<void> pushAndRemoveAllStac(
    BuildContext context,
    String routeName,
  ) => _dispatch(context, StacNavigator.pushAndRemoveAllStac(routeName));

  // --- Flutter named route ------------------------------------------------

  static Future<void> pushFlutter(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? arguments,
  }) => _dispatch(
    context,
    StacNavigator.pushFlutter(routeName, arguments: arguments),
  );

  static Future<void> pushReplacementFlutter(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? result,
    Map<String, dynamic>? arguments,
  }) => _dispatch(
    context,
    StacNavigator.pushReplacementFlutter(
      routeName,
      result: result,
      arguments: arguments,
    ),
  );

  static Future<void> pushAndRemoveAllFlutter(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? arguments,
  }) => _dispatch(
    context,
    StacNavigator.pushAndRemoveAllFlutter(routeName, arguments: arguments),
  );

  // --- inline JSON ---------------------------------------------------------

  static Future<void> pushJson(
    BuildContext context,
    Map<String, dynamic> widgetJson,
  ) => _dispatch(context, StacNavigator.pushJson(widgetJson));

  static Future<void> pushReplacementJson(
    BuildContext context,
    Map<String, dynamic> widgetJson, {
    Map<String, dynamic>? result,
  }) => _dispatch(
    context,
    StacNavigator.pushReplacementJson(widgetJson, result: result),
  );

  static Future<void> pushAndRemoveAllJson(
    BuildContext context,
    Map<String, dynamic> widgetJson,
  ) => _dispatch(context, StacNavigator.pushAndRemoveAllJson(widgetJson));

  // --- local asset -----------------------------------------------------------

  static Future<void> pushAsset(BuildContext context, String assetPath) =>
      _dispatch(context, StacNavigator.pushAsset(assetPath));

  static Future<void> pushReplacementAsset(
    BuildContext context,
    String assetPath, {
    Map<String, dynamic>? result,
  }) => _dispatch(
    context,
    StacNavigator.pushReplacementAsset(assetPath, result: result),
  );

  static Future<void> pushAndRemoveAllAsset(
    BuildContext context,
    String assetPath,
  ) => _dispatch(context, StacNavigator.pushAndRemoveAllAsset(assetPath));

  // --- network -----------------------------------------------------------

  static Future<void> pushNetwork(
    BuildContext context,
    StacNetworkRequest request,
  ) => _dispatch(context, StacNavigator.pushNetwork(request));

  static Future<void> pushReplacementNetwork(
    BuildContext context,
    StacNetworkRequest request, {
    Map<String, dynamic>? result,
  }) => _dispatch(
    context,
    StacNavigator.pushReplacementNetwork(request, result: result),
  );

  static Future<void> pushAndRemoveAllNetwork(
    BuildContext context,
    StacNetworkRequest request,
  ) => _dispatch(context, StacNavigator.pushAndRemoveAllNetwork(request));
}
