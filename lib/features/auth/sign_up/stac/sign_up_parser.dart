import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import 'sign_up_model.dart';
import '../sign_up_page.dart';

class SignUpParser extends StacParser<SignUpModel> {
  const SignUpParser();

  @override
  String get type => 'sign_up';

  @override
  SignUpModel getModel(Map<String, dynamic> json) => SignUpModel.fromJson(json);

  @override
  Widget parse(BuildContext context, SignUpModel model) {
    return SignUpPage();
  }
}
