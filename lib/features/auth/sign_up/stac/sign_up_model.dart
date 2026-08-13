import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'sign_up_model.g.dart';

@JsonSerializable()
class SignUpModel extends StacWidget {
  const SignUpModel();

  @override
  String get type => 'sign_up';

  factory SignUpModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SignUpModelToJson(this);
}
