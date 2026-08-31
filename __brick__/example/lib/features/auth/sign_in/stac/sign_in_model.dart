import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'sign_in_model.g.dart';

@JsonSerializable()
class SignInModel extends StacWidget {
  const SignInModel({
    this.title,
    this.subtitle,
    this.emailHint,
    this.passwordHint,
  });

  final String? title;
  final String? subtitle;
  final String? emailHint;
  final String? passwordHint;

  @override
  String get type => 'sign_in';

  factory SignInModel.fromJson(Map<String, dynamic> json) =>
      _$SignInModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SignInModelToJson(this);
}
