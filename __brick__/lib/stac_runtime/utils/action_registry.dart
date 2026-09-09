import 'package:flutter/material.dart';

/// Signature for actions that return data for injection.
typedef DataAction = Future<dynamic> Function(BuildContext context);

/// Registry for actions that return data for injection into templates.
///
/// Register actions that return `Map<String, dynamic>` or
/// `List<Map<String, dynamic>>` and call them by key from inject-data parsers.
///
/// Example:
/// ```dart
/// ActionRegistry.register('fetch_products', (context) async {
///   final response = await dio.get('/api/products');
///   return response.data;
/// });
/// ```
class ActionRegistry {
  ActionRegistry._();

  static final Map<String, DataAction> _actions = {};

  /// Calls an action by [key] and returns its result.
  static Future<dynamic> call(BuildContext context, String key) async {
    final action = _actions[key];
    if (action == null) {
      throw StateError('Action not found: $key');
    }
    return action(context);
  }

  /// Registers a single action [key] with [action].
  static void register(String key, DataAction action) {
    _actions[key] = action;
  }

  /// Registers multiple actions at once.
  static void registerAll(Map<String, DataAction> actions) {
    _actions.addAll(actions);
  }
}
