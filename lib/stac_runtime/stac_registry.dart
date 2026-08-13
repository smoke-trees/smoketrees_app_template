import 'package:stac/stac.dart';
import 'package:smoketrees_app_template/stac_runtime/actions/to_do/create_to_do/st_create_to_do_action_parser.dart';
import 'package:smoketrees_app_template/stac_runtime/actions/wildcard_page_nav/st_wildcard_page_nav_parser.dart';
import 'package:smoketrees_app_template/stac_runtime/widgets/layout/wildcard_page/wildcard_page_parser.dart';

import '../core/network/dio_controllers/backend_dio.dart';
import '../features/auth/sign_in/stac/sign_in_parser.dart';
import '../features/auth/sign_up/stac/sign_up_parser.dart';
import '../features/counter/stac/counter_screen_parser.dart';
import '../features/splash/stac/splash_page_parser.dart';
import '../features/todo/list/stac/to_do_list_parser.dart';
import '../features/todo/tile/stac/st_to_do_tile_parser.dart';
import 'actions/to_do/delete_to_do/st_delete_to_do_action_parser.dart';
import 'actions/to_do/reorder_to_do/stac_reorder_to_do_action_parser.dart';
import 'actions/to_do/toggle_to_do/st_toggle_to_do_action_parser.dart';
import 'widgets/collections/dismissible/st_dismissible_parser.dart';
import 'widgets/collections/future_data/st_future_data_parser.dart';
import 'widgets/collections/list_view_builder/st_list_view_builder_parser.dart';
import 'widgets/collections/reorderable_list_view_builder/st_reorderable_list_view_builder_parser.dart';
import 'widgets/controls/animated_icon_toggle/st_animated_icon_toggle_parser.dart';
import 'widgets/controls/bottom_bar/st_custom_bottom_bar_parser.dart';
import 'widgets/controls/dialog/st_dialog_parser.dart';
import 'widgets/controls/main_button/st_main_button_parser.dart';
import 'widgets/layout/animated_container/st_animated_container_parser.dart';
import 'widgets/layout/conditional/st_conditional_widget_parser.dart';
import 'widgets/layout/conditional_container/st_conditional_container_parser.dart';
import 'widgets/layout/material/st_material_parser.dart';
import 'widgets/layout/page_view/st_page_view_parser.dart';

class StacParsers {
  static final List<StacParser> parsers = [
    StMainButtonParser(),
    StPageViewParser(),
    StCustomBottomBarParser(),
    StDialogParser(),
    CounterScreenParser(),
    SplashPageParser(),
    SignInParser(),
    SignUpParser(),
    ToDoListParser(),
    StToDoTileParser(),
    StFutureDataParser(backendDio.dio),
    StListViewBuilderParser(),
    StDismissibleParser(),
    StAnimatedContainerParser(),
    StReorderableListViewBuilderParser(),
    StAnimatedIconToggleParser(),
    StConditionalWidgetParser(),
    StConditionalContainerParser(),
    StMaterialParser(),
    WildcardPageParser(),
  ];
  static final List<StacActionParser> actionParsers = [
    StacReorderToDoActionParser(),
    StacToggleToDoActionParser(),
    StacDeleteToDoActionParser(),
    StWildcardPageNavActionParser(),
    StCreateToDoActionParser(),
  ];
}
