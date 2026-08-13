import 'package:stac_core/core/stac_widget.dart';

class StFutureData extends StacWidget {
  final String endpoint;
  final Map<String, dynamic>? loadingWidget; // raw JSON, resolved recursively
  final Map<String, dynamic>? errorWidget;
  final Map<String, dynamic> childTemplate; // raw JSON with {{placeholders}}

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
