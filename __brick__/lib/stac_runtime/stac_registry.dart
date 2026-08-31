import 'package:dio/dio.dart';
import 'package:stac/stac.dart';

// Import custom parsers
import 'widgets/controls/main_button/st_main_button_parser.dart';
import 'widgets/layout/page_view/st_page_view_parser.dart';
import 'widgets/controls/bottom_bar/st_custom_bottom_bar_parser.dart';
import 'widgets/controls/dialog/st_dialog_parser.dart';
import 'widgets/collections/dismissible/st_dismissible_parser.dart';
import 'widgets/layout/animated_container/st_animated_container_parser.dart';
import 'widgets/controls/animated_icon_toggle/st_animated_icon_toggle_parser.dart';
import 'widgets/layout/conditional/st_conditional_widget_parser.dart';
import 'widgets/layout/conditional_container/st_conditional_container_parser.dart';
import 'widgets/layout/material/st_material_parser.dart';
import 'widgets/collections/future_data/st_future_data_parser.dart';
import 'widgets/collections/list_view_builder/st_list_view_builder_parser.dart';
import 'widgets/layout/wildcard_page/wildcard_page_parser.dart';

// Import custom action parsers
import 'actions/wildcard_page_nav/st_wildcard_page_nav_parser.dart';

/// Plain Dio instance — replace with your own instance/interceptors once you
/// have a backend.
final Dio _dio = Dio();

class StacParsers {
  static final List<StacParser> parsers = [
    StMainButtonParser(),
    StPageViewParser(),
    StCustomBottomBarParser(),
    StDialogParser(),
    StDismissibleParser(),
    StAnimatedContainerParser(),
    StAnimatedIconToggleParser(),
    StConditionalWidgetParser(),
    StConditionalContainerParser(),
    StMaterialParser(),
    StFutureDataParser(_dio),
    StListViewBuilderParser(_dio),
    WildcardPageParser(),
  ];

  static final List<StacActionParser> actionParsers = [
    StWildcardPageNavActionParser(),
  ];
}