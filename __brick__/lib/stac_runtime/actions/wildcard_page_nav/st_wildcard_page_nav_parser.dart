import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import 'st_wildcard_page_nav.dart';

/// Parses and dispatches [StWildcardPageNavAction].
///
/// Reuses the exact same dispatch pipeline as the built-in `navigate` action
/// (`Stac.onCallFromJson`) so behavior is identical whether the navigation is
/// triggered from JSON or imperative code.
class StWildcardPageNavActionParser
    extends StacActionParser<StWildcardPageNavAction> {
  const StWildcardPageNavActionParser();

  @override
  String get actionType => 'wildcard_page_nav';

  @override
  StWildcardPageNavAction getModel(Map<String, dynamic> json) =>
      StWildcardPageNavAction.fromJson(json);

  @override
  Future<void> onCall(
    BuildContext context,
    StWildcardPageNavAction action,
  ) async {
    final StacNavigateAction navigateAction = switch (action.navigationType) {
      WildcardPageNavType.push => StacNavigator.pushStac(
        'wildcard_page',
        arguments: action.navigationArguments,
      ),
      WildcardPageNavType.pushReplacement => StacNavigateAction(
        navigationStyle: NavigationStyle.pushReplacement,
        routeName: 'wildcard_page',
        result: action.result,
        arguments: action.navigationArguments,
      ),
      WildcardPageNavType.pushAndRemoveAll => StacNavigateAction(
        navigationStyle: NavigationStyle.pushAndRemoveAll,
        routeName: 'wildcard_page',
        arguments: action.navigationArguments,
      ),
      WildcardPageNavType.pushNamed => StacNavigator.pushFlutter(
        'wildcard_page',
        arguments: action.navigationArguments,
      ),
      WildcardPageNavType.pushNamedAndRemoveAll =>
        StacNavigator.pushAndRemoveAllFlutter(
          'wildcard_page',
          arguments: action.navigationArguments,
        ),
      WildcardPageNavType.pushReplacementNamed =>
        StacNavigator.pushReplacementFlutter(
          'wildcard_page',
          result: action.result,
          arguments: action.navigationArguments,
        ),
      WildcardPageNavType.pop => StacNavigator.pop(result: action.result),
      WildcardPageNavType.popAll => StacNavigator.popAll(),
    };

    await Stac.onCallFromJson(navigateAction.toJson(), context);
  }
}