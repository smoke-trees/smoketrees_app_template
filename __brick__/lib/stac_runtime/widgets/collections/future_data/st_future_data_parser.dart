import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import '../../../utils/inject_data.dart';
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

        // Inject fetched data into the child JSON template before rendering
        final data = snapshot.data!.data as Map<String, dynamic>;
        final resolvedJson = injectData(model.childTemplate, data);

        return Stac.fromJson(resolvedJson, context) ?? const SizedBox();
      },
    );
  }

  @override
  String get type => 'future_data';
}
