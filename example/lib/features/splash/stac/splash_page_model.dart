import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'splash_page_model.g.dart';

@JsonSerializable()
class SplashPageModel extends StacWidget {
  final String logoAsset;
  const SplashPageModel({required this.logoAsset});

  @override
  String get type => 'splash_page';

  factory SplashPageModel.fromJson(Map<String, dynamic> json) =>
      _$SplashPageModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SplashPageModelToJson(this);
}
