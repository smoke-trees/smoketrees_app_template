import 'package:{{project_name.snakeCase()}}/{{project_name.snakeCase()}}.dart';
import 'package:stac/stac.dart';

import '../core/network/dio_controllers/backend_dio.dart';
import '../features/auth/sign_in/stac/sign_in_parser.dart';
import '../features/auth/sign_up/stac/sign_up_parser.dart';
import '../features/counter/stac/counter_screen_parser.dart';
import '../features/splash/stac/splash_page_parser.dart';
import '../features/todo/list/stac/to_do_list_parser.dart';
import '../features/todo/tile/stac/st_to_do_tile_parser.dart';
import 'actions/action_registry.dart';
import 'actions/to_do/create_to_do/st_create_to_do_action_parser.dart';
import 'actions/to_do/delete_to_do/st_delete_to_do_action_parser.dart';
import 'actions/to_do/reorder_to_do/stac_reorder_to_do_action_parser.dart';
import 'actions/to_do/toggle_to_do/st_toggle_to_do_action_parser.dart';
import 'widgets/collections/reorderable_list_view_builder/st_reorderable_list_view_builder_parser.dart';

class StacParsers {
  static final List<StacParser> parsers = [
    StMainButtonParser(onActionKey: ActionRegistry.call),
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
    StListViewBuilderParser(backendDio.dio),
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
