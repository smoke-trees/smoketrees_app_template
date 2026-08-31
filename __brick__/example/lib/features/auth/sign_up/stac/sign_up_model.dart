import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'sign_up_model.g.dart';

@JsonSerializable()
class SignUpModel extends StacWidget {
  const SignUpModel({
    this.title,
    this.subtitle,
    this.nameHint,
    this.emailHint,
    this.passwordHint,
  });

  final String? title;
  final String? subtitle;
  final String? nameHint;
  final String? emailHint;
  final String? passwordHint;

  @override
  String get type => 'sign_up';

  factory SignUpModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SignUpModelToJson(this);
}
