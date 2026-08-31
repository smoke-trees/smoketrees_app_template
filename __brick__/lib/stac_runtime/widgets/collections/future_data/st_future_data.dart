import 'package:stac/stac_core.dart';

class StFutureData extends StacWidget {
  final String endpoint;
  final Map<String, dynamic>? loadingWidget;
  final Map<String, dynamic>? errorWidget;
  final Map<String, dynamic> childTemplate;

  const StFutureData({
    required this.endpoint,
    required this.childTemplate,
    this.loadingWidget,
    this.errorWidget,
  });

  @override
  String get type => 'future_data';

  factory StFutureData.fromJson(Map<String, dynamic> json) => StFutureData(
    endpoint: json['endpoint'],
    childTemplate: json['child'],
    loadingWidget: json['loadingWidget'],
    errorWidget: json['errorWidget'],
  );

  Map<String, dynamic> toJson() => {
    'type': type,
    'endpoint': endpoint,
    'child': childTemplate,
    'loadingWidget': loadingWidget,
    'errorWidget': errorWidget,
  };
}
