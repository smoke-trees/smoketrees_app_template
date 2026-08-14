import 'package:smoketrees_app_template/stac_runtime/actions/wildcard_page_nav/st_wildcard_page_nav.dart';
import 'package:smoketrees_app_template/stac_runtime/widgets/controls/bottom_bar/st_custom_bottom_bar.dart';
import 'package:smoketrees_app_template/stac_runtime/widgets/controls/main_button/st_main_button.dart';
import 'package:smoketrees_app_template/stac_runtime/widgets/layout/page_view/st_page_view.dart';
import 'package:stac/stac_core.dart';

import '../../lib/utils/assets.dart';
import '../../stac/lib/bottom_navigation/st_to_do_list_view.dart';
import '../../stac/lib/hello_world.dart';

List<String> labels = ['Home', 'Inspiration', 'Obsessed', 'My Bag', 'Profile'];

List<String> svgIcons = [
  AppAssets.searchSvg,
  AppAssets.ideaSvg,
  AppAssets.heartSvg,
  AppAssets.bagSvg,
  AppAssets.profileSvg,
];

List<String> svgFilledIcons = [
  AppAssets.searchFilledSvg,
  AppAssets.ideaFilledSvg,
  AppAssets.heartFilledSvg,
  AppAssets.bagFilledSvg,
  AppAssets.profileFilledSvg,
];

@StacScreen(screenName: "bottom_navigation")
StacWidget bottomNavigation() {
  return StacDefaultNavigationController(
    length: labels.length,
    child: StacScaffold(
      backgroundColor: StacColors.white,
      bottomNavigationBar: StacSafeArea(
        child: StCustomBottomBar(
          labels: labels,
          svgIcons: svgIcons,
          svgFilledIcons: svgFilledIcons,
        ),
      ),
      body: StacSafeArea(
        child: StPageView(
          children: [
            stToDoListView(),
            // ToDoListModel(
            //   appBarTitle: 'To Do List',
            //   toDoTileModel: ToDoTileModel(
            //     serialNumberMarkWidth: 32,
            //     serialNumberMarkHeight: 32,
            //   ),
            // ),
            StacScaffold(),
            StacScaffold(
              body: StacCenter(
                child: StacText(
                  data: 'Profile',
                  style: StacTextStyle(fontSize: 24),
                ),
              ),
            ),
            helloWorld(),
            StacScaffold(
              body: StacColumn(
                children: [
                  StacText(
                    data: 'Bottom Navigation',
                    style: StacTextStyle(fontSize: 24),
                  ),
                  StMainButton(
                    title: 'Got to profile test page',
                    onPressed: StWildcardPageNavAction(
                      navigationType: WildcardPageNavType.pushNamed,
                      wildcardPage: 'page2',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
