import 'package:stac/stac_core.dart';
import 'package:smoketrees_app_template/stac_runtime/widgets/controls/main_button/st_main_button.dart';

StacWidget page2() => StacScaffold(
  body: StacColumn(
    children: [
      StacText(data: 'Page 2', style: StacTextStyle(fontSize: 24)),
      StMainButton(title: 'Got back', onPressed: StacNavigator.pop()),
    ],
  ),
);
