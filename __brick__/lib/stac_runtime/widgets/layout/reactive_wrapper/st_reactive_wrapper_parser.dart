import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stac/stac.dart';

import '../../../utils/inject_data.dart';
import 'st_reactive_wrapper.dart';

class StReactiveWrapperParser extends StacParser<StReactiveWrapper> {
  @override
  String get type => 'st_reactive_wrapper';

  @override
  StReactiveWrapper getModel(Map<String, dynamic> json) =>
      StReactiveWrapper.fromJson(json);

  @override
  Widget parse(BuildContext context, StReactiveWrapper model) {
    return Obx(() {
      // DataRegistry must be registered by the app to provide
      // reactive data streams. Example:
      // DataRegistry.register('habits', () => HealthHabitsController.to.habits);
      final dataSource = DataRegistry.get(model.dataSourceKey);
      if (dataSource == null) return const SizedBox();

      final items = dataSource();
      if (items is! List) return const SizedBox();

      final match = items.where((item) =>
          item is Map<String, dynamic> && item['id'] == model.id);
      if (match.isEmpty) return const SizedBox();

      final item = match.first as Map<String, dynamic>;
      final childJson = model.child.toJson();
      final resolvedJson = injectData(childJson, item);
      return Stac.fromJson(resolvedJson, context) ?? const SizedBox();
    });
  }
}

/// Registry for reactive data sources.
/// Register your GetX observables here.
class DataRegistry {
  DataRegistry._();

  static final Map<String, Function> _sources = {};

  static void register(String key, Function source) {
    _sources[key] = source;
  }

  static Function? get(String key) => _sources[key];
}
