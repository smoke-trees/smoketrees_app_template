import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

import '../../../utils/action_registry.dart';
import '../../../utils/inject_data.dart';
import 'st_generic_data_list.dart';

class StGenericDataListParser extends StacParser<StGenericDataList> {
  final Dio dio;

  StGenericDataListParser({Dio? dio}) : dio = dio ?? Dio();

  @override
  String get type => 'st_generic_data_list';

  @override
  StGenericDataList getModel(Map<String, dynamic> json) =>
      StGenericDataList.fromJson(json);

  @override
  Widget parse(BuildContext context, StGenericDataList model) {
    if (model.actionKey != null && model.actionKey!.isNotEmpty) {
      return _buildWithAction(context, model);
    }
    if (model.endpoint == null || model.endpoint!.isEmpty) {
      return _buildWithItems(context, model, model.items ?? const []);
    }
    return _buildWithEndpoint(context, model);
  }

  Widget _buildWithAction(BuildContext context, StGenericDataList model) {
    return FutureBuilder<dynamic>(
      future: ActionRegistry.call(context, model.actionKey!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _stateWidget(model.loadingWidget, context) ??
              const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _stateWidget(model.errorWidget, context) ??
              const Center(child: Text('Failed to load'));
        }
        final data = snapshot.data;
        if (data == null) {
          return _stateWidget(model.emptyWidget, context) ?? const SizedBox();
        }
        if (data is List) {
          final items = data.cast<Map<String, dynamic>>();
          return _buildList(context, model, items);
        }
        final mapData = data is Map<String, dynamic> ? data : {'data': data};
        final resolvedJson = injectData(model.childTemplate, mapData);
        return Stac.fromJson(resolvedJson, context) ?? const SizedBox();
      },
    );
  }

  Widget _buildWithItems(
    BuildContext context,
    StGenericDataList model,
    List<Map<String, dynamic>> items,
  ) {
    if (items.isEmpty) {
      return _stateWidget(model.emptyWidget, context) ?? const SizedBox();
    }
    if (items.length == 1) {
      final resolvedJson = injectData(model.childTemplate, items.first);
      return Stac.fromJson(resolvedJson, context) ?? const SizedBox();
    }
    return _buildList(context, model, items);
  }

  Widget _buildList(
    BuildContext context,
    StGenericDataList model,
    List<Map<String, dynamic>> items,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < items.length; i++)
          Builder(
            builder: (context) {
              final itemWithIndex = <String, dynamic>{...items[i], 'index': i};
              final resolvedJson = injectData(model.childTemplate, itemWithIndex);
              return Stac.fromJson(resolvedJson, context) ?? const SizedBox();
            },
          ),
      ],
    );
  }

  Widget _buildWithEndpoint(BuildContext context, StGenericDataList model) {
    return FutureBuilder<dynamic>(
      future: dio.get(model.endpoint!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _stateWidget(model.loadingWidget, context) ??
              const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _stateWidget(model.errorWidget, context) ??
              const Center(child: Text('Failed to load'));
        }
        final data = snapshot.data!.data;
        final Map<String, dynamic> mapData =
            data is Map<String, dynamic> ? data : {'data': data as Object};
        final resolvedJson = injectData(model.childTemplate, mapData);
        return Stac.fromJson(resolvedJson, context) ?? const SizedBox();
      },
    );
  }

  Widget? _stateWidget(Map<String, dynamic>? json, BuildContext context) {
    return json == null ? null : Stac.fromJson(json, context);
  }
}
