import 'package:stac/stac_core.dart';
import '../../lib/features/splash/stac/splash_page_model.dart';
import '../../lib/utils/assets.dart';

@StacScreen(screenName: "splash_page")
StacWidget stSplashPage() {
  return SplashPageModel(logoAsset: AppAssets.animatedAppLogo);
}
