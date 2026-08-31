import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import 'splash_page_model.dart';

class SplashPageParser extends StacParser<SplashPageModel> {
  @override
  String get type => 'splash_page';

  @override
  SplashPageModel getModel(Map<String, dynamic> json) =>
      SplashPageModel.fromJson(json);

  @override
  Widget parse(BuildContext context, SplashPageModel model) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.flutter_dash,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              model.title ?? 'Splash',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (model.subtitle != null) ...[
              const SizedBox(height: 10),
              Text(model.subtitle!),
            ],
            const SizedBox(height: 10),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
