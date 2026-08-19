import 'package:dio/dio.dart';
import 'package:smoketrees_app_template/smoketrees_app_template.dart';
import 'package:stac/stac.dart';

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
    StSubmitOrderActionParser(),
    StSubmitOrderActionParser(),
  ];
}
