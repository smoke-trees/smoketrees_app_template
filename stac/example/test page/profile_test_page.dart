import 'package:stac/stac_core.dart';
import 'package:smoketrees_app_template/stac_runtime/widgets/controls/main_button/st_main_button.dart';

@StacScreen(screenName: "profile_test_page")
StacWidget profileTestPage() {
  return StacScaffold(
    body: StacCenter(
      child: StacContainer(
        child: StacColumn(
          mainAxisAlignment: StacMainAxisAlignment.center,
          crossAxisAlignment: StacCrossAxisAlignment.center,
          children: [
            StacText(
              data: 'Profile Test Page: {{productId}}',
              style: StacTextStyle(fontSize: 16),
            ),
            StMainButton(
              onPressed: StacNavigator.pop(),
              title: 'Back',
              textStyle: StacTextStyle(fontSize: 16, color: StacColors.white),
              borderRadius: 30,
            ),
          ],
        ),
      ),
    ),
  );
}
