import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import 'sign_in_model.dart';
import '../sign_in_page.dart';

class SignInParser extends StacParser<SignInModel> {
  const SignInParser();

  @override
  String get type => 'sign_in';

  @override
  SignInModel getModel(Map<String, dynamic> json) => SignInModel.fromJson(json);

  @override
  Widget parse(BuildContext context, SignInModel model) {
    return const SignInPage();
  }
}
