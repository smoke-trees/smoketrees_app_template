import 'package:smoketrees_app_template/stac_runtime/widgets/controls/main_button/st_main_button.dart';
import 'package:stac/stac_core.dart';

StacWidget helloWorld() {
  return StacScaffold(
    backgroundColor: StacColors.white,
    body: StacCenter(
      child: StacColumn(
        mainAxisAlignment: StacMainAxisAlignment.center,
        crossAxisAlignment: StacCrossAxisAlignment.center,
        children: [
          StMainButton(
            actionKey: 'go_to_tab_1',
            title: 'Go to Tab 1',
            textStyle: StacTextStyle(fontSize: 16, color: StacColors.white),
          ),
        ],
      ),
    ),
  );
}
