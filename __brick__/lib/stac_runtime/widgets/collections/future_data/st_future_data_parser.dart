import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import 'st_future_data.dart';

class StFutureDataParser extends StacParser<StFutureData> {
  final Dio dio;
  StFutureDataParser(this.dio);

  @override
  StFutureData getModel(Map<String, dynamic> json) =>
      StFutureData.fromJson(json);

  @override
  Widget parse(BuildContext context, StFutureData model) {
    return FutureBuilder<Response>(
      future: dio.get(model.endpoint),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return model.loadingWidget != null
              ? Stac.fromJson(model.loadingWidget, context) ?? const SizedBox()
              : const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || snapshot.data?.statusCode != 200) {
          return model.errorWidget != null
              ? Stac.fromJson(model.errorWidget, context) ?? const SizedBox()
              : const Center(child: Text('Failed to load'));
        }

        final data = snapshot.data!.data as Map<String, dynamic>;
        final resolvedJson = _injectData(model.childTemplate, data);

        return Stac.fromJson(resolvedJson, context) ?? const SizedBox();
      },
    );
  }

  dynamic _injectData(dynamic node, Map<String, dynamic> data) {
    if (node is String) {
      final match = RegExp(r'^\{\{(\w+)\}\}$').firstMatch(node);
      if (match != null) return data[match.group(1)] ?? node;
      return node.replaceAllMapped(
        RegExp(r'\{\{(\w+)\}\}'),
        (m) => data[m.group(1)]?.toString() ?? m.group(0)!,
      );
    }
    if (node is Map<String, dynamic>) {
      return node.map((k, v) => MapEntry(k, _injectData(v, data)));
    }
    if (node is List) {
      return node.map((e) => _injectData(e, data)).toList();
    }
    return node;
  }

  @override
  String get type => 'future_data';
}
