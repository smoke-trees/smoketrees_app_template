import 'package:stac/stac_core.dart';
import 'package:smoketrees_app_template/stac_runtime/actions/wildcard_page_nav/st_wildcard_page_nav.dart';
import 'package:smoketrees_app_template/stac_runtime/widgets/controls/main_button/st_main_button.dart';

StacWidget page1() => StacScaffold(
  body: StacColumn(
    children: [
      StacText(data: 'Page 1', style: StacTextStyle(fontSize: 24)),
      StMainButton(
        title: 'Got to page 2',
        onPressed: StWildcardPageNavAction(
          navigationType: WildcardPageNavType.push,
          wildcardPage: 'page2',
        ),
      ),
    ],
  ),
);
