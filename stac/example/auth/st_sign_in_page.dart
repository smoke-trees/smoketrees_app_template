import 'package:stac/stac_core.dart';
import 'package:smoketrees_app_template/features/auth/sign_in/stac/sign_in_model.dart';

@StacScreen(screenName: "sign_in")
StacWidget stSignInPage() {
  return const SignInModel();
}
