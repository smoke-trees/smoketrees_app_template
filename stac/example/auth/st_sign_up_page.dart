import 'package:stac/stac_core.dart';
import 'package:smoketrees_app_template/features/auth/sign_up/stac/sign_up_model.dart';

@StacScreen(screenName: "sign_up")
StacWidget stSignUpPage() {
  return const SignUpModel();
}
