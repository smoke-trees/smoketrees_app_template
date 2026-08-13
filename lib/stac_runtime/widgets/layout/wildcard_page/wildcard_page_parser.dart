import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:smoketrees_app_template/shared/cards/custom_error_cards.dart';

import 'wildcard_page.dart';

class WildcardPageParser extends StacParser<WildcardPage> {
  @override
  String get type => 'st_wildcard_page';

  @override
  WildcardPage getModel(Map<String, dynamic> json) =>
      WildcardPage.fromJson(json);

  @override
  Widget parse(BuildContext context, WildcardPage model) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg != null &&
        arg is Map<String, dynamic> &&
        arg.containsKey('wildcardPage')) {
      return model.children[arg['wildcardPage']]?.parse(context) ??
          CustomErrorCard(error: 'Unexpected error in parsing');
    }
    return CustomErrorCard(error: 'No widgets added or argumentIndex is null');
  }
}
