import 'package:flutter/cupertino.dart';
import 'package:stac/stac.dart';
import '../splash_page.dart';
import 'splash_page_model.dart';

class SplashPageParser extends StacParser<SplashPageModel> {
  const SplashPageParser();

  @override
  String get type => 'splash_page';

  @override
  SplashPageModel getModel(Map<String, dynamic> json) =>
      SplashPageModel.fromJson(json);

  @override
  Widget parse(BuildContext context, SplashPageModel model) {
    return SplashPage(logoAsset: model.logoAsset);
  }
}
