import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import '../../app/app_nav.dart';
import '../../utils/console_logger.dart';

typedef RegisteredAction = Future<void> Function(BuildContext context);

class ActionRegistry {
  static final Map<String, RegisteredAction> _actions = {
    'hello_world': (context) async {
      ConsoleLogger.info('hello_world');
      await AppNav.pushStac(context, 'profile_test_page');
    },
    'back_profile_test_page': (context) async {
      ConsoleLogger.info('back');
      await Stac.onCallFromJson(StacNavigator.pop().toJson(), context);
    },
    'go_to_tab_1': (context) async {
      NavigationScope.of(context)?.controller.index = 0;
    },
  };

  static RegisteredAction? resolve(String? key) =>
      key == null ? null : _actions[key];

  static void register(String key, RegisteredAction action) {
    _actions[key] = action;
  }

  static void registerAll(Map<String, RegisteredAction> actions) {
    _actions.addAll(actions);
  }
}
