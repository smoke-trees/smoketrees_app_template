import 'package:stac/stac_core.dart';
import 'package:smoketrees_app_template/features/splash/stac/splash_page_model.dart';
import 'package:smoketrees_app_template/utils/assets.dart';

@StacScreen(screenName: "splash_page")
StacWidget stSplashPage() {
  return SplashPageModel(logoAsset: AppAssets.animatedAppLogo);
}
